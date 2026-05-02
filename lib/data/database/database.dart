import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// --- Core Tables ---

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get role => text()(); // Admin, Manager, Cashier
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('Setting')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

// --- Categories Table ---

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // Category name (required)
  IntColumn get parentId => integer().nullable()(); // For subcategories - references parent category ID
  TextColumn get description => text().nullable()(); // Optional description
  TextColumn get imageUrl => text().nullable()(); // Optional image path/URL
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Inventory Tables ---

@DataClassName('Medicine')
class Medicines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get code => text().unique()(); // Barcode/Unique ID
  TextColumn get mainCategory => text().withDefault(const Constant('General'))(); // Category name
  TextColumn get subCategory => text().nullable()(); // Subcategory name
  TextColumn get manufacturer => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get minStock => integer().withDefault(const Constant(10))(); // Low stock alert level
  
  // Added in v8 for generic inventory support
  TextColumn get brand => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get genericName => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get baseUnitName => text().withDefault(const Constant('Unit'))();
}

@DataClassName('Batch')
class Batches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicineId => integer().references(Medicines, #id)();
  TextColumn get batchNumber => text()();
  DateTimeColumn get expiryDate => dateTime()();
  RealColumn get purchasePrice => real()();
  RealColumn get salePrice => real()();
  IntColumn get quantity => integer()(); // Current stock in this batch
  IntColumn get packSize => integer().withDefault(const Constant(1))(); // Added in v7
}

@DataClassName('ProductUnit')
class ProductUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicineId => integer().references(Medicines, #id)();
  TextColumn get name => text()();
  RealColumn get conversionFactor => real().withDefault(const Constant(1.0))();
  RealColumn get salePrice => real()();
  BoolColumn get isBaseUnit => boolean().withDefault(const Constant(false))();
  BoolColumn get isDefaultSaleUnit => boolean().withDefault(const Constant(false))();
}

// --- Customer Tables ---

@DataClassName('Customer')
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // Required
  TextColumn get phoneNumber => text().nullable()(); // Optional but validated if provided
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Sales & Billing Tables ---

@DataClassName('Sale')
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get customerId => integer().nullable().references(Customers, #id)(); // Customer who made the purchase
  DateTimeColumn get date => dateTime()();
  RealColumn get subTotal => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get tax => real().withDefault(const Constant(0.0))();
  RealColumn get posFee => real().withDefault(const Constant(0.0))(); // POS Fee column
  RealColumn get grandTotal => real()();
  TextColumn get paymentMethod => text().withDefault(const Constant('Cash'))();
  IntColumn get userId => integer().nullable().references(Users, #id)(); // Who processed the sale
}

@DataClassName('SaleItem')
class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get batchId => integer().references(Batches, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()(); // Price at moment of sale
  RealColumn get total => real()();
  TextColumn get unitName => text().nullable()(); // Added in v9
  RealColumn get conversionFactor => real().withDefault(const Constant(1.0))(); // Added in v9
}

@DriftDatabase(tables: [Users, Settings, Categories, Medicines, Batches, ProductUnits, Customers, Sales, SaleItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 9; // Updated to 9

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          try {
            await m.addColumn(medicines, medicines.mainCategory);
            await m.addColumn(medicines, medicines.subCategory);
          } catch (e) { /* ignore */ }
        }
        if (from < 4) {
          try {
            await m.createTable(customers);
            await m.addColumn(sales, sales.customerId);
          } catch (e) { /* ignore */ }
        }
        if (from < 5) {
          try {
            await m.createTable(categories);
          } catch (e) { /* ignore */ }
        }
        if (from < 6) {
          try {
            await m.addColumn(sales, sales.posFee);
          } catch (e) { /* ignore */ }
        }
        if (from < 7) {
          try {
            await m.addColumn(batches, batches.packSize);
          } catch (e) { /* ignore */ }
        }
        if (from < 8) {
          // 1. Create the new units table
          await m.createTable(productUnits);
          
          // 2. Add columns to medicines
          await m.addColumn(medicines, medicines.brand);
          await m.addColumn(medicines, medicines.model);
          await m.addColumn(medicines, medicines.genericName);
          await m.addColumn(medicines, medicines.strength);
          await m.addColumn(medicines, medicines.dosageForm);
          await m.addColumn(medicines, medicines.baseUnitName);

          // 3. Data Migration: Create default units for existing products
          // We use customStatement to avoid dependency on the latest Dart classes during migration
          await customStatement('''
            INSERT INTO product_units (medicine_id, name, conversion_factor, sale_price, is_base_unit, is_default_sale_unit)
            SELECT m.id, 'Unit', 1.0, 
                   IFNULL((SELECT b.sale_price FROM batches b WHERE b.medicine_id = m.id ORDER BY b.id DESC LIMIT 1), 0.0),
                   1, 1
            FROM medicines m;
          ''');
        }
        if (from < 9) {
          await m.addColumn(saleItems, saleItems.unitName);
          await m.addColumn(saleItems, saleItems.conversionFactor);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pharmacy_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

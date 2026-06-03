import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../data/repositories/custom_field_repository.dart';
import '../../data/providers/current_shop_provider.dart';
import '../../data/database/database.dart';

final customFieldServiceProvider = Provider<CustomFieldService>((ref) {
  final repo = ref.watch(customFieldRepositoryProvider);
  final securityKey = ref.watch(currentShopProvider.select((s) => s?['securityKey'] as String?));
  return CustomFieldService(repo, securityKey);
});

class CustomFieldService {
  final CustomFieldRepository _repo;
  final String? _securityKey;

  CustomFieldService(this._repo, this._securityKey);

  bool get _isValid => _securityKey != null && _securityKey.isNotEmpty;

  // ─── Default Business Fields ────────────────────────────────────────────────

  Future<void> ensureDefaultFields(String businessType) async {
    if (!_isValid) return;

    final existing = await _repo.getAllDefinitions(_securityKey!);
    final existingKeys = existing.map((e) => '${e.entityType}_${e.fieldKey}').toSet();

    final defaults = _getDefaultFieldsFor(businessType);
    for (final def in defaults) {
      final uniqueKey = '${def.entityType}_${def.fieldKey}';
      if (!existingKeys.contains(uniqueKey)) {
        await _repo.saveDefinition(def);
      }
    }
  }

  List<CustomFieldDefinitionsCompanion> _getDefaultFieldsFor(String businessType) {
    List<CustomFieldDefinitionsCompanion> fields = [];
    final t = DateTime.now();
    
    CustomFieldDefinitionsCompanion buildDef(String entityType, String fieldKey, String label, String type, bool pos, bool cart, bool inv, {String? options}) {
      return CustomFieldDefinitionsCompanion.insert(
        securityKey: _securityKey!,
        businessType: Value(businessType),
        entityType: entityType,
        fieldKey: fieldKey,
        fieldLabel: label,
        fieldType: type,
        optionsJson: Value(options),
        showInProductForm: const Value(true),
        showInPOS: Value(pos),
        showInCart: Value(cart),
        showInInvoice: Value(inv),
        showInReports: const Value(true),
        createdAt: Value(t),
        updatedAt: Value(t),
      );
    }

    if (businessType == 'Pharmacy') {
      fields.addAll([
        buildDef('product', 'rack_no', 'Rack No', 'text', true, false, false),
        buildDef('product', 'shelf_no', 'Shelf No', 'text', true, false, false),
        buildDef('product', 'prescription_req', 'Prescription Required', 'checkbox', true, false, false),
      ]);
    } else if (businessType == 'Electronics') {
      fields.addAll([
        buildDef('product', 'processor', 'Processor', 'text', true, true, true),
        buildDef('product', 'ram', 'RAM', 'text', true, true, true),
        buildDef('product', 'storage', 'Storage', 'text', true, true, true),
        buildDef('product', 'battery_health', 'Battery Health', 'text', true, true, true),
      ]);
    } else if (businessType == 'Restaurant') {
      fields.addAll([
        buildDef('product', 'kitchen_section', 'Kitchen Section', 'dropdown', true, false, false, options: '["Grill", "Drinks", "Kitchen", "Desserts"]'),
        buildDef('product', 'prep_time', 'Preparation Time (mins)', 'number', true, false, false),
        buildDef('product', 'food_type', 'Food Type', 'dropdown', true, false, false, options: '["Veg", "Non-Veg", "Vegan"]'),
      ]);
    } else if (businessType == 'Clothing') {
      fields.addAll([
        buildDef('product', 'fabric', 'Fabric', 'text', true, true, true),
        buildDef('product', 'collection', 'Collection', 'text', true, true, true),
        buildDef('product', 'fit_type', 'Fit Type', 'dropdown', true, false, false, options: '["Slim", "Regular", "Loose"]'),
      ]);
    }
    
    return fields;
  }

  // ─── Reading ────────────────────────────────────────────────────────────────

  Future<List<CustomFieldDefinition>> getActiveProductFields(String businessType) async {
    if (!_isValid) return [];
    return await _repo.getDefinitions(
      securityKey: _securityKey!,
      entityType: 'product',
      businessType: businessType,
      onlyActive: true,
    );
  }

  Future<List<CustomFieldValue>> getValues(String entityType, int entityId) async {
    if (!_isValid) return [];
    return await _repo.getValuesForEntity(_securityKey!, entityType, entityId);
  }

  // ─── Writing & Validation ───────────────────────────────────────────────────

  String? validateRequiredFields(List<CustomFieldDefinition> definitions, Map<int, String?> formValues) {
    for (final def in definitions) {
      if (def.isActive && def.showInProductForm && def.isRequired) {
        final val = formValues[def.id];
        if (val == null || val.trim().isEmpty) {
          return '${def.fieldLabel} is required';
        }
      }
    }
    return null;
  }

  Future<void> saveProductValues(int productId, Map<int, CustomFieldValuesCompanion> values) async {
    if (!_isValid) return;
    await _repo.saveValues(_securityKey!, 'product', productId, values.values.toList());
  }
}

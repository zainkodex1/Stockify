import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

final customFieldRepositoryProvider = Provider<CustomFieldRepository>((ref) {
  return CustomFieldRepository(ref.watch(databaseProvider));
});

class CustomFieldRepository {
  final AppDatabase _db;

  CustomFieldRepository(this._db);

  // ─── Definitions ─────────────────────────────────────────────────────────────

  Future<List<CustomFieldDefinition>> getDefinitions({
    required String securityKey,
    required String entityType,
    String? businessType,
    bool onlyActive = false,
  }) async {
    final query = _db.select(_db.customFieldDefinitions)
      ..where((t) => t.securityKey.equals(securityKey) & t.entityType.equals(entityType));

    if (onlyActive) {
      query.where((t) => t.isActive.equals(true));
    }

    if (businessType != null) {
      query.where((t) => t.businessType.equals(businessType) | t.businessType.isNull());
    }

    query.orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]);
    return await query.get();
  }
  
  Future<List<CustomFieldDefinition>> getAllDefinitions(String securityKey) async {
    final query = _db.select(_db.customFieldDefinitions)
      ..where((t) => t.securityKey.equals(securityKey))
      ..orderBy([(t) => OrderingTerm(expression: t.entityType, mode: OrderingMode.asc), (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]);
    return await query.get();
  }

  Future<CustomFieldDefinition> saveDefinition(CustomFieldDefinitionsCompanion definition) async {
    final id = await _db.into(_db.customFieldDefinitions).insert(definition, mode: InsertMode.insertOrReplace);
    final query = _db.select(_db.customFieldDefinitions)..where((t) => t.id.equals(id));
    return await query.getSingle();
  }
  
  Future<void> updateDefinition(CustomFieldDefinitionsCompanion definition) async {
    await _db.update(_db.customFieldDefinitions).replace(definition);
  }

  // ─── Values ──────────────────────────────────────────────────────────────────

  Future<List<CustomFieldValue>> getValuesForEntity(String securityKey, String entityType, int entityId) async {
    final query = _db.select(_db.customFieldValues)
      ..where((t) =>
          t.securityKey.equals(securityKey) &
          t.entityType.equals(entityType) &
          t.entityId.equals(entityId));
    return await query.get();
  }

  Future<List<CustomFieldValue>> getValuesForEntities(String securityKey, String entityType, List<int> entityIds) async {
    if (entityIds.isEmpty) return [];
    final query = _db.select(_db.customFieldValues)
      ..where((t) =>
          t.securityKey.equals(securityKey) &
          t.entityType.equals(entityType) &
          t.entityId.isIn(entityIds));
    return await query.get();
  }

  Future<void> saveValues(String securityKey, String entityType, int entityId, List<CustomFieldValuesCompanion> values) async {
    await _db.transaction(() async {
      // Clear old values for this entity to prevent stale data if user cleared a field
      await (_db.delete(_db.customFieldValues)
            ..where((t) =>
                t.securityKey.equals(securityKey) &
                t.entityType.equals(entityType) &
                t.entityId.equals(entityId)))
          .go();

      for (final value in values) {
        final companion = value.copyWith(
          securityKey: Value(securityKey),
          entityType: Value(entityType),
          entityId: Value(entityId),
        );
        await _db.into(_db.customFieldValues).insert(companion);
      }
    });
  }
}

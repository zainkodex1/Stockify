import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/settings_repository.dart';

class BusinessPresetService {
  final SettingsRepository _settingsRepository;

  BusinessPresetService(this._settingsRepository);

  /// Normalizes any raw business type string into a standard preset category
  String normalizeBusinessType(String? rawType) {
    if (rawType == null || rawType.trim().isEmpty) {
      if (kDebugMode) {
        print('[BusinessPresetService] Empty or null businessType. Falling back to Pharmacy.');
      }
      return 'Pharmacy';
    }

    final input = rawType.toLowerCase().trim();
    if (input.contains('pharmacy') || input.contains('medical')) {
      return 'Pharmacy';
    } else if (input.contains('electronics') || input.contains('mobile') || input.contains('laptop') || input.contains('device')) {
      return 'Electronics';
    } else if (input.contains('restaurant') || input.contains('cafe') || input.contains('food court')) {
      return 'Restaurant';
    } else if (input.contains('cloth') || input.contains('fashion') || input.contains('garment') || input.contains('apparel')) {
      return 'Clothing';
    } else if (input.contains('grocery') || input.contains('supermarket')) {
      return 'Grocery';
    } else {
      return 'General';
    }
  }

  /// Automatically configures local SQLite settings based on business type.
  /// This sets both visibility flags AND requirement flags for all core fields.
  Future<void> applyPresetFromBusinessType(String? businessType) async {
    final normalized = normalizeBusinessType(businessType);
    if (kDebugMode) {
      print('[BusinessPresetService] Raw businessType: "$businessType" -> Normalized to: "$normalized"');
    }

    // ── Visibility defaults (true = shown) ──
    bool showBrand = true;
    bool showModel = false;
    bool showGenericName = false;
    bool showStrength = false;
    bool showDosageForm = false;
    bool showSKU = true;
    bool showBarcode = true;
    bool showImage = false;
    bool showCategory = true;
    bool showSubCategory = true;
    bool showMinStock = true;
    bool enableBatch = true;
    bool enableExpiry = true;
    bool enableMultiUnit = false;
    bool showPurchasePrice = true;
    bool posShowUnitSelector = false;
    bool posBlockOOS = false;

    // ── Requirement defaults (false = optional) ──
    bool reqName = true;   // Product Name is always required unless explicitly turned off
    bool reqBrand = false;
    bool reqModel = false;
    bool reqGeneric = false;
    bool reqStrength = false;
    bool reqDosage = false;
    bool reqSKU = false;
    bool reqBarcode = false;
    bool reqCategory = false;
    bool reqSubCategory = false;
    bool reqBatch = false;
    bool reqExpiry = false;
    bool reqStock = false;

    // ── Stock Tracking & Decimal Qty ──
    // NOTE: decimal quantity is NOT supported until Batches/SaleItems columns
    // are migrated from integer to real (double). See stock_helpers.dart TODO.
    bool stockTrackingEnabled = true;

    if (normalized == 'Pharmacy') {
      showBrand = true;
      showGenericName = true;
      showStrength = true;
      showDosageForm = true;
      enableBatch = true;
      enableExpiry = true;
      enableMultiUnit = true;
      posShowUnitSelector = true;
      posBlockOOS = true;
      stockTrackingEnabled = true;
      // Pharmacy requires batch + expiry by default
      reqBatch = true;
      reqExpiry = true;
    } else if (normalized == 'Electronics') {
      showBrand = true;
      showModel = true;
      showGenericName = false;
      showStrength = false;
      showDosageForm = false;
      enableBatch = true; // Batch field repurposed for Serial/IMEI
      enableExpiry = false;
      enableMultiUnit = false;
      posShowUnitSelector = false;
      posBlockOOS = true;
      stockTrackingEnabled = true;
      reqBrand = true;
      reqModel = false;
    } else if (normalized == 'Restaurant') {
      showBrand = false;
      showGenericName = false;
      showStrength = false;
      showDosageForm = false;
      enableBatch = false;
      enableExpiry = false;
      enableMultiUnit = false;
      posShowUnitSelector = false;
      posBlockOOS = false;
      // Restaurant: stock tracking OFF by default — sell even if no stock
      stockTrackingEnabled = false;
    } else if (normalized == 'Clothing') {
      showBrand = true;
      showModel = false;
      showGenericName = false;
      showStrength = false;
      showDosageForm = false;
      enableBatch = false;
      enableExpiry = false;
      enableMultiUnit = false;
      posBlockOOS = false;
      stockTrackingEnabled = true;
    } else if (normalized == 'Grocery') {
      showBrand = false;
      showGenericName = false;
      showStrength = false;
      showDosageForm = false;
      enableBatch = false;
      enableExpiry = true;
      enableMultiUnit = true;
      posShowUnitSelector = true;
      stockTrackingEnabled = true;
      // NOTE: decimal quantities are NOT enabled here.
      // Grocery decimal qty (e.g. 1.5 Kg) requires migrating Batches.quantity
      // and SaleItems.quantity from IntColumn to RealColumn. See TODO in stock_helpers.dart.
    } else { // General
      showBrand = true;
      enableBatch = true;
      enableExpiry = true;
      enableMultiUnit = false;
      posShowUnitSelector = false;
      stockTrackingEnabled = true;
    }

    // ── Write all visibility settings ──
    await _settingsRepository.saveSetting('inv_business_type', normalized);
    await _settingsRepository.saveSetting('form_show_brand', showBrand.toString());
    await _settingsRepository.saveSetting('form_show_manufacturer', showBrand.toString());
    await _settingsRepository.saveSetting('form_show_model', showModel.toString());
    await _settingsRepository.saveSetting('form_show_generic_name', showGenericName.toString());
    await _settingsRepository.saveSetting('form_show_strength', showStrength.toString());
    await _settingsRepository.saveSetting('form_show_dosage_form', showDosageForm.toString());
    await _settingsRepository.saveSetting('form_show_sku', showSKU.toString());
    await _settingsRepository.saveSetting('form_show_barcode', showBarcode.toString());
    await _settingsRepository.saveSetting('form_show_image', showImage.toString());
    await _settingsRepository.saveSetting('form_show_category', showCategory.toString());
    await _settingsRepository.saveSetting('form_show_sub_category', showSubCategory.toString());
    await _settingsRepository.saveSetting('form_show_min_stock', showMinStock.toString());
    await _settingsRepository.saveSetting('inv_enable_batch', enableBatch.toString());
    await _settingsRepository.saveSetting('form_show_batch_number', enableBatch.toString());
    await _settingsRepository.saveSetting('inv_enable_expiry', enableExpiry.toString());
    await _settingsRepository.saveSetting('form_show_expiry_date', enableExpiry.toString());
    await _settingsRepository.saveSetting('inv_multi_unit', enableMultiUnit.toString());
    await _settingsRepository.saveSetting('form_show_purchase_price', showPurchasePrice.toString());
    await _settingsRepository.saveSetting('pos_show_unit_selector', posShowUnitSelector.toString());
    await _settingsRepository.saveSetting('pos_block_oos', posBlockOOS.toString());
    await _settingsRepository.saveSetting('inv_stock_tracking_enabled', stockTrackingEnabled.toString());

    // ── Write requirement settings ──
    await _settingsRepository.saveSetting('form_req_name', reqName.toString());
    await _settingsRepository.saveSetting('form_req_brand', reqBrand.toString());
    await _settingsRepository.saveSetting('form_req_model', reqModel.toString());
    await _settingsRepository.saveSetting('form_req_generic', reqGeneric.toString());
    await _settingsRepository.saveSetting('form_req_strength', reqStrength.toString());
    await _settingsRepository.saveSetting('form_req_dosage', reqDosage.toString());
    await _settingsRepository.saveSetting('form_req_sku', reqSKU.toString());
    await _settingsRepository.saveSetting('form_req_barcode', reqBarcode.toString());
    await _settingsRepository.saveSetting('form_req_category', reqCategory.toString());
    await _settingsRepository.saveSetting('form_req_sub_category', reqSubCategory.toString());
    await _settingsRepository.saveSetting('form_req_batch', reqBatch.toString());
    await _settingsRepository.saveSetting('form_req_expiry', reqExpiry.toString());
    await _settingsRepository.saveSetting('form_req_stock', reqStock.toString());

    if (kDebugMode) {
      print('[BusinessPresetService] Successfully applied settings preset for "$normalized".');
    }
  }
}

final businessPresetServiceProvider = Provider<BusinessPresetService>((ref) {
  return BusinessPresetService(ref.watch(settingsRepositoryProvider));
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/settings_repository.dart';
import '../shared/app_theme.dart';

class InventoryFlowSettingsScreen extends ConsumerStatefulWidget {
  const InventoryFlowSettingsScreen({super.key});

  @override
  ConsumerState<InventoryFlowSettingsScreen> createState() => _InventoryFlowSettingsScreenState();
}

class _InventoryFlowSettingsScreenState extends ConsumerState<InventoryFlowSettingsScreen> {
  bool _isLoading = true;
  
  // Business Type
  String _businessType = 'General';

  // Identity Fields
  bool _showBrand = true;
  bool _showModel = false;
  bool _showGenericName = false;
  bool _showStrength = false;
  bool _showDosageForm = false;
  bool _showSKU = true;
  bool _showBarcode = true;
  bool _showImage = false;
  bool _showCategory = true;
  bool _showSubCategory = true;
  bool _showMinStock = true;

  // Inventory Engine
  bool _enableBatch = true;
  bool _enableExpiry = true;
  bool _enableMultiUnit = false;
  bool _showPurchasePrice = true;

  // POS Behavior
  bool _posShowUnitSelector = false;
  bool _posBlockOOS = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    
    final bizType = await repo.getSetting('inv_business_type');
    final showBrand = await repo.getSetting('form_show_brand');
    final showModel = await repo.getSetting('form_show_model');
    final showGeneric = await repo.getSetting('form_show_generic_name');
    final showStrength = await repo.getSetting('form_show_strength');
    final showDosage = await repo.getSetting('form_show_dosage_form');
    final showSKU = await repo.getSetting('form_show_sku');
    final showBarcode = await repo.getSetting('form_show_barcode');
    final showImage = await repo.getSetting('form_show_image');
    
    // Existing keys compatibility
    final showMfg = await repo.getSetting('form_show_manufacturer');
    final showMin = await repo.getSetting('form_show_min_stock');
    final showBatch = await repo.getSetting('inv_enable_batch') ?? await repo.getSetting('form_show_batch_number');
    final showExp = await repo.getSetting('inv_enable_expiry') ?? await repo.getSetting('form_show_expiry_date');
    final showBuy = await repo.getSetting('form_show_purchase_price');
    final showCat = await repo.getSetting('form_show_category');
    final showSub = await repo.getSetting('form_show_sub_category');
    
    final multiUnit = await repo.getSetting('inv_multi_unit');
    final posUnitSel = await repo.getSetting('pos_show_unit_selector');
    final blockOOS = await repo.getSetting('pos_block_oos');

    if (mounted) {
      setState(() {
        _businessType = bizType ?? 'General';
        _showBrand = (showBrand ?? showMfg) != 'false';
        _showModel = showModel == 'true';
        _showGenericName = showGeneric == 'true';
        _showStrength = showStrength == 'true';
        _showDosageForm = showDosage == 'true';
        _showSKU = showSKU != 'false';
        _showBarcode = showBarcode != 'false';
        _showImage = showImage == 'true';
        _showCategory = showCat != 'false';
        _showSubCategory = showSub != 'false';
        _showMinStock = showMin != 'false';
        
        _enableBatch = showBatch != 'false';
        _enableExpiry = showExp != 'false';
        _enableMultiUnit = multiUnit == 'true';
        _showPurchasePrice = showBuy != 'false';
        
        _posShowUnitSelector = posUnitSel == 'true';
        _posBlockOOS = blockOOS == 'true';
        
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSetting(String key, String value) async {
    await ref.read(settingsRepositoryProvider).saveSetting(key, value);
  }

  void _applyPreset(String type) {
    setState(() {
      _businessType = type;
      _saveSetting('inv_business_type', type);
      
      if (type == 'Pharmacy') {
        _showBrand = true;
        _showGenericName = true;
        _showStrength = true;
        _showDosageForm = true;
        _enableBatch = true;
        _enableExpiry = true;
        _enableMultiUnit = true;
        _posShowUnitSelector = true;
      } else if (type == 'Electronics') {
        _showBrand = true;
        _showModel = true;
        _showGenericName = false;
        _enableBatch = true;
        _enableExpiry = false;
        _enableMultiUnit = false;
      } else if (type == 'Grocery') {
        _showBrand = false;
        _showGenericName = false;
        _enableBatch = false;
        _enableExpiry = true;
        _enableMultiUnit = true;
      } else if (type == 'General') {
        _showBrand = true;
        _showModel = false;
        _showGenericName = false;
        _enableBatch = true;
        _enableExpiry = true;
        _enableMultiUnit = false;
      }
      
      // Save all changed values
      _saveAll();
    });
  }

  Future<void> _saveAll() async {
    _saveSetting('form_show_brand', _showBrand.toString());
    _saveSetting('form_show_manufacturer', _showBrand.toString()); // Sync with old key
    _saveSetting('form_show_model', _showModel.toString());
    _saveSetting('form_show_generic_name', _showGenericName.toString());
    _saveSetting('form_show_strength', _showStrength.toString());
    _saveSetting('form_show_dosage_form', _showDosageForm.toString());
    _saveSetting('form_show_sku', _showSKU.toString());
    _saveSetting('form_show_barcode', _showBarcode.toString());
    _saveSetting('form_show_image', _showImage.toString());
    _saveSetting('form_show_category', _showCategory.toString());
    _saveSetting('form_show_sub_category', _showSubCategory.toString());
    _saveSetting('form_show_min_stock', _showMinStock.toString());
    
    _saveSetting('inv_enable_batch', _enableBatch.toString());
    _saveSetting('form_show_batch_number', _enableBatch.toString()); // Sync
    _saveSetting('inv_enable_expiry', _enableExpiry.toString());
    _saveSetting('form_show_expiry_date', _enableExpiry.toString()); // Sync
    _saveSetting('inv_multi_unit', _enableMultiUnit.toString());
    _saveSetting('form_show_purchase_price', _showPurchasePrice.toString());
    
    _saveSetting('pos_show_unit_selector', _posShowUnitSelector.toString());
    _saveSetting('pos_block_oos', _posBlockOOS.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(
        title: const Text('Inventory Flow Control'),
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(32),
              children: [
                const Text('Global Business Preset', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const Text('Select your business type to automatically configure the recommended fields', style: TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 24),
                _buildPresetSelector(),
                
                const SizedBox(height: 48),
                _buildSectionHeader('Product Identity Fields', 'Decide which details are collected during product enrollment'),
                _buildSectionCard(
                  'Visual & Identification', Icons.fingerprint_rounded, AppTheme.royalBlue,
                  [
                    _buildSwitch('Brand / Manufacturer', _showBrand, (v) => setState(() { _showBrand = v; _saveSetting('form_show_brand', v.toString()); _saveSetting('form_show_manufacturer', v.toString()); })),
                    _buildSwitch('Model / Version', _showModel, (v) => setState(() { _showModel = v; _saveSetting('form_show_model', v.toString()); })),
                    _buildSwitch('Generic Name / Molecule', _showGenericName, (v) => setState(() { _showGenericName = v; _saveSetting('form_show_generic_name', v.toString()); })),
                    _buildSwitch('Product Strength (e.g. 500mg)', _showStrength, (v) => setState(() { _showStrength = v; _saveSetting('form_show_strength', v.toString()); })),
                    _buildSwitch('Dosage Form (e.g. Tablet)', _showDosageForm, (v) => setState(() { _showDosageForm = v; _saveSetting('form_show_dosage_form', v.toString()); })),
                    _buildSwitch('SKU / Reference Code', _showSKU, (v) => setState(() { _showSKU = v; _saveSetting('form_show_sku', v.toString()); })),
                    _buildSwitch('Barcode Scanning', _showBarcode, (v) => setState(() { _showBarcode = v; _saveSetting('form_show_barcode', v.toString()); })),
                    _buildSwitch('Product Images', _showImage, (v) => setState(() { _showImage = v; _saveSetting('form_show_image', v.toString()); })),
                  ]
                ),
                
                const SizedBox(height: 32),
                _buildSectionCard(
                  'Organization', Icons.layers_rounded, Colors.purple,
                  [
                    _buildSwitch('Main Categories', _showCategory, (v) => setState(() { _showCategory = v; _saveSetting('form_show_category', v.toString()); })),
                    _buildSwitch('Sub-Categories', _showSubCategory, (v) => setState(() { _showSubCategory = v; _saveSetting('form_show_sub_category', v.toString()); })),
                    _buildSwitch('Low Stock Alerts', _showMinStock, (v) => setState(() { _showMinStock = v; _saveSetting('form_show_min_stock', v.toString()); })),
                  ]
                ),

                const SizedBox(height: 48),
                _buildSectionHeader('Inventory & Pricing Engine', 'Configure how stock and costs are managed'),
                _buildSectionCard(
                  'Stock Tracking', Icons.inventory_2_rounded, AppTheme.tealAccent,
                  [
                    _buildSwitch('Batch-wise Tracking (FIFO)', _enableBatch, (v) => setState(() { _enableBatch = v; _saveSetting('inv_enable_batch', v.toString()); _saveSetting('form_show_batch_number', v.toString()); })),
                    _buildSwitch('Expiry Date Monitoring', _enableExpiry, (v) => setState(() { _enableExpiry = v; _saveSetting('inv_enable_expiry', v.toString()); _saveSetting('form_show_expiry_date', v.toString()); })),
                    _buildSwitch('Purchase Price (Costing)', _showPurchasePrice, (v) => setState(() { _showPurchasePrice = v; _saveSetting('form_show_purchase_price', v.toString()); })),
                    _buildSwitch('Multi-Unit Support (e.g. Box/Strip)', _enableMultiUnit, (v) => setState(() { _enableMultiUnit = v; _saveSetting('inv_multi_unit', v.toString()); })),
                  ]
                ),

                const SizedBox(height: 48),
                _buildSectionHeader('POS Behavior', 'Control the checkout experience'),
                _buildSectionCard(
                  'Sales Interface', Icons.point_of_sale_rounded, AppTheme.amberWarning,
                  [
                    _buildSwitch('Enable Unit Selector in POS', _posShowUnitSelector, (v) => setState(() { _posShowUnitSelector = v; _saveSetting('pos_show_unit_selector', v.toString()); })),
                    _buildSwitch('Strict Stock Control (Block if 0)', _posBlockOOS, (v) => setState(() { _posBlockOOS = v; _saveSetting('pos_block_oos', v.toString()); })),
                  ]
                ),
                
                const SizedBox(height: 60),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPresetSelector() {
    final types = ['General', 'Pharmacy', 'Grocery', 'Electronics'];
    return Row(
      children: types.map((t) => _buildPresetChip(t)).toList(),
    );
  }

  Widget _buildPresetChip(String type) {
    final active = _businessType == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => _applyPreset(type),
          borderRadius: BorderRadius.circular(AppTheme.r12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: active ? AppTheme.royalBlue : AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.r12),
              border: Border.all(color: active ? AppTheme.royalBlue : AppTheme.border),
              boxShadow: active ? AppTheme.softShadow : null,
            ),
            child: Column(
              children: [
                Icon(_getIconForType(type), color: active ? Colors.white : AppTheme.textSecondary, size: 24),
                const SizedBox(height: 8),
                Text(type, style: TextStyle(color: active ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w800, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Pharmacy': return Icons.medical_services_rounded;
      case 'Grocery': return Icons.local_grocery_store_rounded;
      case 'Electronics': return Icons.devices_other_rounded;
      default: return Icons.storefront_rounded;
    }
  }

  Widget _buildSectionCard(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(AppTheme.r20), border: Border.all(color: AppTheme.border), boxShadow: AppTheme.softShadow),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppTheme.r8)), child: Icon(icon, color: color, size: 20)),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.royalBlue,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/settings_repository.dart';
import '../shared/app_theme.dart';

class ProductFormSettingsScreen extends ConsumerStatefulWidget {
  const ProductFormSettingsScreen({super.key});

  @override
  ConsumerState<ProductFormSettingsScreen> createState() => _ProductFormSettingsScreenState();
}

class _ProductFormSettingsScreenState extends ConsumerState<ProductFormSettingsScreen> {
  bool _showManufacturer = true;
  bool _showMinStock = true;
  bool _showBatch = true;
  bool _showExpiry = true;
  bool _showPurchasePrice = true;
  bool _showCategory = true;
  bool _showSubCategory = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final showMfg = await repo.getSetting('form_show_manufacturer');
    final showMin = await repo.getSetting('form_show_min_stock');
    final showBatch = await repo.getSetting('form_show_batch_number');
    final showExp = await repo.getSetting('form_show_expiry_date');
    final showBuy = await repo.getSetting('form_show_purchase_price');
    final showCat = await repo.getSetting('form_show_category');
    final showSub = await repo.getSetting('form_show_sub_category');

    if (mounted) {
      setState(() {
        _showManufacturer = showMfg != 'false';
        _showMinStock = showMin != 'false';
        _showBatch = showBatch != 'false';
        _showExpiry = showExp != 'false';
        _showPurchasePrice = showBuy != 'false';
        _showCategory = showCat != 'false';
        _showSubCategory = showSub != 'false';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    await ref.read(settingsRepositoryProvider).saveSetting(key, value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(title: const Text('Dynamic Form Layout'), backgroundColor: AppTheme.surface, surfaceTintColor: Colors.transparent),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(32),
            children: [
              const Text('Form Visibility Controls', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const Text('Hide or show specific fields in the product enrollment dialog to simplify your workflow', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),
              
              _buildSectionCard(
                'Master Data Fields', Icons.data_usage_rounded, AppTheme.royalBlue,
                [
                  _buildSwitch('Category Assignment', _showCategory, (v) => setState(() { _showCategory = v; _saveSetting('form_show_category', v); })),
                  _buildSwitch('Sub-Category Detail', _showSubCategory, (v) => setState(() { _showSubCategory = v; _saveSetting('form_show_sub_category', v); })),
                  _buildSwitch('Manufacturer / Brand', _showManufacturer, (v) => setState(() { _showManufacturer = v; _saveSetting('form_show_manufacturer', v); })),
                  _buildSwitch('Low Stock Alert Trigger', _showMinStock, (v) => setState(() { _showMinStock = v; _saveSetting('form_show_min_stock', v); })),
                ]
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                'Batch & Finance Fields', Icons.account_balance_wallet_rounded, AppTheme.tealAccent,
                [
                  _buildSwitch('Manual Batch Entry', _showBatch, (v) => setState(() { _showBatch = v; _saveSetting('form_show_batch_number', v); })),
                  _buildSwitch('Product Expiry Tracking', _showExpiry, (v) => setState(() { _showExpiry = v; _saveSetting('form_show_expiry_date', v); })),
                  _buildSwitch('Purchase Price Visibility', _showPurchasePrice, (v) => setState(() { _showPurchasePrice = v; _saveSetting('form_show_purchase_price', v); })),
                ]
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppTheme.infoSurface, borderRadius: BorderRadius.circular(AppTheme.r16), border: Border.all(color: AppTheme.royalBlue.withValues(alpha: 0.1))),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppTheme.royalBlue),
                    SizedBox(width: 16),
                    Expanded(child: Text('Hidden fields will use system defaults (0 for prices, auto-ID for batches). You can toggle these back anytime.', style: TextStyle(color: AppTheme.royalBlue, fontSize: 13, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            ],
          ),
    );
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

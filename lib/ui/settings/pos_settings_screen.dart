import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/current_shop_provider.dart';
import '../../data/repositories/shop_repository.dart';
import '../shared/app_theme.dart';

class PosSettingsScreen extends ConsumerStatefulWidget {
  const PosSettingsScreen({super.key});

  @override
  ConsumerState<PosSettingsScreen> createState() => _PosSettingsScreenState();
}

class _PosSettingsScreenState extends ConsumerState<PosSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _gstController;
  late TextEditingController _taxController;
  late TextEditingController _posFeeController;
  late TextEditingController _discountController;
  
  String _gstType = 'percent';
  String _taxType = 'percent';
  String _posFeeType = 'fixed';
  String _discountType = 'percent';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final shop = ref.read(currentShopProvider);
    _gstController = TextEditingController(text: (shop?['gstRate'] ?? 0).toString());
    _taxController = TextEditingController(text: (shop?['taxRate'] ?? 0).toString());
    _posFeeController = TextEditingController(text: (shop?['posFee'] ?? 0).toString());
    _discountController = TextEditingController(text: (shop?['defaultDiscount'] ?? 0).toString());
    _gstType = shop?['gstType'] ?? 'percent';
    _taxType = shop?['taxType'] ?? 'percent';
    _posFeeType = shop?['posFeeType'] ?? 'fixed';
    _discountType = shop?['discountType'] ?? 'percent';
  }

  @override
  void dispose() {
    _gstController.dispose();
    _taxController.dispose();
    _posFeeController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final currentMap = ref.read(currentShopProvider);
      final email = currentMap?['email'] as String?;
      if (email != null) {
        await ref.read(shopRepositoryProvider).updatePosSettings(
          email: email, gstRate: double.tryParse(_gstController.text) ?? 0,
          taxRate: double.tryParse(_taxController.text) ?? 0,
          posFee: double.tryParse(_posFeeController.text) ?? 0,
          defaultDiscount: double.tryParse(_discountController.text) ?? 0,
          gstType: _gstType, taxType: _taxType, posFeeType: _posFeeType, discountType: _discountType,
        );
        final updated = Map<String, dynamic>.from(currentMap!);
        updated['gstRate'] = double.tryParse(_gstController.text) ?? 0;
        updated['taxRate'] = double.tryParse(_taxController.text) ?? 0;
        updated['posFee'] = double.tryParse(_posFeeController.text) ?? 0;
        updated['defaultDiscount'] = double.tryParse(_discountController.text) ?? 0;
        updated['gstType'] = _gstType; updated['taxType'] = _taxType;
        updated['posFeeType'] = _posFeeType; updated['discountType'] = _discountType;
        ref.read(currentShopProvider.notifier).setShop(updated);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('POS Settings updated'), backgroundColor: AppTheme.emeraldSuccess));
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.redDanger));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(title: const Text('Checkout Configuration'), backgroundColor: AppTheme.surface, surfaceTintColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Calculations & Defaults', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const Text('Configure how taxes and fees are applied during checkout', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildGroup(
                      'Taxes & Levies', Icons.account_balance_rounded, AppTheme.royalBlue,
                      [
                        _buildField(_gstController, 'GST / VAT', _gstType, (v) => setState(() => _gstType = v)),
                        const SizedBox(height: 24),
                        _buildField(_taxController, 'Extra Service Tax', _taxType, (v) => setState(() => _taxType = v)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildGroup(
                      'Fees & Rewards', Icons.settings_suggest_rounded, AppTheme.tealAccent,
                      [
                        _buildField(_posFeeController, 'Fixed POS Service Fee', _posFeeType, (v) => setState(() => _posFeeType = v)),
                        const SizedBox(height: 24),
                        _buildField(_discountController, 'Default Store Discount', _discountType, (v) => setState(() => _discountType = v)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveSettings,
                  icon: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_circle_rounded),
                  label: const Text('APPLY SYSTEM SETTINGS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.royalBlue, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(AppTheme.r20), border: Border.all(color: AppTheme.border), boxShadow: AppTheme.softShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppTheme.r8)), child: Icon(icon, color: color, size: 20)),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, String type, ValueChanged<String> onTypeChg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textSecondary)),
            _buildToggle(type, onTypeChg),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(suffixText: type == 'percent' ? '%' : 'PKR', filled: true, fillColor: AppTheme.surfaceVariant),
        ),
      ],
    );
  }

  Widget _buildToggle(String type, ValueChanged<String> onChg) {
    return Container(
      height: 32, padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn('%', type == 'percent', () => onChg('percent')),
          _buildToggleBtn('Fixed', type == 'fixed', () => onChg('fixed')),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(AppTheme.r6), boxShadow: active ? [const BoxShadow(color: Colors.black12, blurRadius: 2)] : null),
        child: Text(text, style: TextStyle(color: active ? AppTheme.primaryNavy : AppTheme.textMuted, fontSize: 11, fontWeight: active ? FontWeight.w800 : FontWeight.w500)),
      ),
    );
  }
}

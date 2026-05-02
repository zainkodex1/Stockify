import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../data/repositories/medicine_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';

enum PricingMode { single, pack }

class AddProductDialog extends ConsumerStatefulWidget {
  final Medicine? medicine;
  const AddProductDialog({super.key, this.medicine});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _manufacturerController;
  late TextEditingController _minStockController;
  late TextEditingController _batchNoController;
  late TextEditingController _qtyController; 
  late TextEditingController _unitPurchasePriceController; 
  late TextEditingController _unitSalePriceController; 
  late TextEditingController _packSizeController;
  late TextEditingController _numPacksController;
  late TextEditingController _packPurchasePriceController;
  late TextEditingController _packSalePriceController;

  late FocusNode _nameFocus;
  late FocusNode _manufacturerFocus;
  late FocusNode _minStockFocus;
  late FocusNode _batchNoFocus;
  late FocusNode _qtyFocus;
  late FocusNode _unitPurchaseFocus;
  late FocusNode _unitSaleFocus;
  late FocusNode _packSizeFocus;
  late FocusNode _numPacksFocus;
  late FocusNode _packPurchaseFocus;
  late FocusNode _packSaleFocus;

  String? _selectedMainCategory;
  String? _selectedSubCategory;
  Map<String, List<String>> _categories = {};
  PricingMode _pricingMode = PricingMode.single;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  List<Medicine> _allMedicines = [];
  Medicine? _selectedExistingMedicine;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.name ?? '');
    _manufacturerController = TextEditingController(text: widget.medicine?.manufacturer ?? '');
    _minStockController = TextEditingController(text: widget.medicine?.minStock.toString() ?? '10');
    _batchNoController = TextEditingController();
    _qtyController = TextEditingController();
    _unitPurchasePriceController = TextEditingController();
    _unitSalePriceController = TextEditingController();
    _packSizeController = TextEditingController(text: '10');
    _numPacksController = TextEditingController();
    _packPurchasePriceController = TextEditingController();
    _packSalePriceController = TextEditingController();

    _nameFocus = FocusNode();
    _manufacturerFocus = FocusNode();
    _minStockFocus = FocusNode();
    _batchNoFocus = FocusNode();
    _qtyFocus = FocusNode();
    _unitPurchaseFocus = FocusNode();
    _unitSaleFocus = FocusNode();
    _packSizeFocus = FocusNode();
    _numPacksFocus = FocusNode();
    _packPurchaseFocus = FocusNode();
    _packSaleFocus = FocusNode();

    if (widget.medicine != null) {
      _selectedMainCategory = widget.medicine!.mainCategory;
      _selectedSubCategory = widget.medicine!.subCategory;
    }
    _selectedExistingMedicine = widget.medicine;
    _loadCategories();
    if (widget.medicine == null) {
      _loadLastCategory();
      _loadAllMedicines();
    }
    _packSizeController.addListener(_calculateUnitFromPack);
    _packSalePriceController.addListener(_calculateUnitFromPack);
    _packPurchasePriceController.addListener(_calculateUnitFromPack);
    _numPacksController.addListener(_calculateTotalQtyFromPack);
  }

  void _calculateUnitFromPack() {
    if (_pricingMode == PricingMode.pack) {
      final size = double.tryParse(_packSizeController.text) ?? 1;
      final safeSize = size <= 0 ? 1 : size;
      final pSale = double.tryParse(_packSalePriceController.text) ?? 0;
      final pCost = double.tryParse(_packPurchasePriceController.text) ?? 0;
      if (_packSalePriceController.text.isNotEmpty) _unitSalePriceController.text = (pSale / safeSize).toStringAsFixed(2);
      if (_packPurchasePriceController.text.isNotEmpty) _unitPurchasePriceController.text = (pCost / safeSize).toStringAsFixed(2);
    }
  }

  void _calculateTotalQtyFromPack() {
    if (_pricingMode == PricingMode.pack) {
      final size = int.tryParse(_packSizeController.text) ?? 1;
      final packs = int.tryParse(_numPacksController.text) ?? 0;
      _qtyController.text = (packs * size).toString();
    }
  }

  Future<void> _loadCategories() async {
    final cats = await ref.read(categoryRepositoryProvider).getCategoriesAsMap();
    if (mounted) setState(() { 
      _categories = cats;
      if (_selectedMainCategory != null && !_categories.containsKey(_selectedMainCategory)) _categories[_selectedMainCategory!] = [];
    });
  }

  Future<void> _loadLastCategory() async {
    final repo = ref.read(settingsRepositoryProvider);
    final lastMain = await repo.getSetting('last_main_category');
    final lastSub = await repo.getSetting('last_sub_category');
    if (mounted && _selectedMainCategory == null) {
      setState(() {
        if (lastMain != null && _categories.containsKey(lastMain)) {
          _selectedMainCategory = lastMain;
          if (lastSub != null && _categories[lastMain]!.contains(lastSub)) _selectedSubCategory = lastSub;
        } else { _selectedMainCategory = 'General'; }
      });
    }
  }

  Future<void> _loadAllMedicines() async {
    final meds = await ref.read(medicineRepositoryProvider).getAllMedicines();
    if (mounted) setState(() => _allMedicines = meds);
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(medicineRepositoryProvider);
      final sRepo = ref.read(settingsRepositoryProvider);
      if (_selectedMainCategory != null) await sRepo.saveSetting('last_main_category', _selectedMainCategory!);
      if (_selectedSubCategory != null) await sRepo.saveSetting('last_sub_category', _selectedSubCategory!);

      int mid;
      if (_selectedExistingMedicine != null) {
        mid = _selectedExistingMedicine!.id;
        await repo.updateMedicine(_selectedExistingMedicine!.copyWith(
          name: _nameController.text,
          mainCategory: _selectedMainCategory ?? 'General',
          subCategory: drift.Value(_selectedSubCategory),
          manufacturer: drift.Value(_manufacturerController.text),
          minStock: int.tryParse(_minStockController.text) ?? 10,
        ));
      } else {
        mid = await repo.addMedicine(MedicinesCompanion(
          name: drift.Value(_nameController.text),
          mainCategory: drift.Value(_selectedMainCategory ?? 'General'),
          subCategory: drift.Value(_selectedSubCategory),
          manufacturer: drift.Value(_manufacturerController.text),
          minStock: drift.Value(int.tryParse(_minStockController.text) ?? 10),
          code: drift.Value(DateTime.now().millisecondsSinceEpoch.toString()),
        ));
      }

      final fQty = int.tryParse(_qtyController.text) ?? 0;
      final fSale = double.tryParse(_unitSalePriceController.text) ?? 0.0;
      if (fQty > 0 || fSale > 0) {
        if (_batchNoController.text.isEmpty) _batchNoController.text = 'B-${DateTime.now().millisecondsSinceEpoch}';
        await repo.addBatch(BatchesCompanion(
          medicineId: drift.Value(mid),
          batchNumber: drift.Value(_batchNoController.text),
          quantity: drift.Value(fQty),
          purchasePrice: drift.Value(double.tryParse(_unitPurchasePriceController.text) ?? 0.0),
          salePrice: drift.Value(fSale),
          expiryDate: drift.Value(_expiryDate),
          packSize: drift.Value(_pricingMode == PricingMode.pack ? (int.tryParse(_packSizeController.text) ?? 1) : 1),
        ));
      }
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 850,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        color: AppTheme.surface,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
                child: Row(
                  children: [
                    const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 28),
                    const SizedBox(width: 16),
                    Text(widget.medicine == null ? 'Inventory Enrollment' : 'Modify Product', 
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close_rounded, color: Colors.white70), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Basic Information'),
                      const SizedBox(height: 16),
                      _buildNameField(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildDropdown('Main Category', _selectedMainCategory, _categories.keys.toList(), (v) => setState(() { _selectedMainCategory = v; _selectedSubCategory = null; }))),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDropdown('Sub Category', _selectedSubCategory, _selectedMainCategory == null ? [] : (_categories[_selectedMainCategory!] ?? []), (v) => setState(() => _selectedSubCategory = v))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_manufacturerController, 'Manufacturer / Brand', Icons.factory_rounded)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField(_minStockController, 'Low Stock Alert Level', Icons.warning_amber_rounded, isNumeric: true)),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildSectionTitle('Stock & Pricing Strategy'),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r16), border: Border.all(color: AppTheme.border)),
                        child: Column(
                          children: [
                            _buildPricingModeToggle(),
                            const SizedBox(height: 24),
                            if (_pricingMode == PricingMode.pack) _buildPackInputs(),
                            if (_pricingMode == PricingMode.pack) const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                            _buildUnitResults(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildTextField(_batchNoController, 'Batch Identifier', Icons.qr_code_rounded)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildDatePicker()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: AppTheme.surface, border: Border(top: BorderSide(color: AppTheme.border))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(minimumSize: const Size(120, 50)), child: const Text('CANCEL')),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('SAVE TO INVENTORY', style: TextStyle(fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.royalBlue, foregroundColor: Colors.white, minimumSize: const Size(200, 50)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryNavy));

  Widget _buildNameField() {
    return LayoutBuilder(builder: (context, c) {
      return RawAutocomplete<Medicine>(
        textEditingController: _nameController,
        focusNode: _nameFocus,
        optionsBuilder: (v) => v.text.isEmpty ? const Iterable<Medicine>.empty() : _allMedicines.where((m) => m.name.toLowerCase().contains(v.text.toLowerCase())),
        displayStringForOption: (m) => m.name,
        onSelected: (m) => setState(() {
          _selectedExistingMedicine = m; _nameController.text = m.name; _manufacturerController.text = m.manufacturer ?? '';
          _minStockController.text = m.minStock.toString(); _selectedMainCategory = m.mainCategory; _selectedSubCategory = m.subCategory;
        }),
        fieldViewBuilder: (ctx, ctrl, focus, onSub) => TextFormField(
          controller: ctrl, focusNode: focus,
          decoration: const InputDecoration(labelText: 'Search or Enter Product Name', prefixIcon: Icon(Icons.search_rounded)),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
        optionsViewBuilder: (ctx, onSel, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8, borderRadius: BorderRadius.circular(12),
            child: Container(width: c.maxWidth, constraints: const BoxConstraints(maxHeight: 250), child: ListView.builder(
              padding: EdgeInsets.zero, shrinkWrap: true, itemCount: options.length,
              itemBuilder: (ctx, i) {
                final m = options.elementAt(i);
                return ListTile(title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(m.mainCategory), onTap: () => onSel(m));
              },
            )),
          ),
        ),
      );
    });
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {bool isNumeric = false, bool readOnly = false}) {
    return TextFormField(
      controller: ctrl, readOnly: readOnly,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), fillColor: readOnly ? AppTheme.surface : Colors.white, filled: true),
      validator: (v) => !readOnly && isNumeric && (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdown(String label, String? val, List<String> items, ValueChanged<String?> onChg) {
    return DropdownButtonFormField<String>(
      value: val, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChg, decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.layers_rounded, size: 20), fillColor: Colors.white, filled: true),
      validator: (v) => v == null ? 'Required' : null,
    );
  }

  Widget _buildPricingModeToggle() {
    return Row(
      children: [
        _buildModeChip('Piece / Unit', PricingMode.single, Icons.extension_rounded),
        const SizedBox(width: 12),
        _buildModeChip('Box / Pack', PricingMode.pack, Icons.all_inbox_rounded),
      ],
    );
  }

  Widget _buildModeChip(String label, PricingMode mode, IconData icon) {
    final active = _pricingMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _pricingMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: active ? AppTheme.royalBlue : Colors.white, borderRadius: BorderRadius.circular(AppTheme.r12), border: Border.all(color: active ? AppTheme.royalBlue : AppTheme.border)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? Colors.white : AppTheme.textSecondary, size: 18),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: active ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w800, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackInputs() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField(_packSizeController, 'Units per Pack', Icons.numbers_rounded, isNumeric: true)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(_numPacksController, 'Total Packs In Stock', Icons.inventory_2_rounded, isNumeric: true)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(_packPurchasePriceController, 'Pack Purchase Cost', Icons.shopping_cart_rounded, isNumeric: true)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(_packSalePriceController, 'Pack Sale Price', Icons.sell_rounded, isNumeric: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitResults() {
    final isPack = _pricingMode == PricingMode.pack;
    return Row(
      children: [
        Expanded(child: _buildTextField(_qtyController, 'Total Units', Icons.balance_rounded, isNumeric: true, readOnly: isPack)),
        const SizedBox(width: 16),
        Expanded(child: _buildTextField(_unitPurchasePriceController, 'Unit Cost', Icons.currency_exchange_rounded, isNumeric: true, readOnly: isPack)),
        const SizedBox(width: 16),
        Expanded(child: _buildTextField(_unitSalePriceController, 'Unit Sale Price', Icons.payments_rounded, isNumeric: true, readOnly: isPack)),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: _expiryDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 3650)));
        if (d != null) setState(() => _expiryDate = d);
      },
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Expiry Date', prefixIcon: Icon(Icons.event_rounded, size: 20), fillColor: Colors.white, filled: true),
        child: Text(DateFormat('MMM dd, yyyy').format(_expiryDate), style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

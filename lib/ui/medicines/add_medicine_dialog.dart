import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../data/repositories/medicine_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/database/database.dart';
import '../../core/config/custom_field_service.dart';
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
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _genericNameController;
  late TextEditingController _strengthController;
  late TextEditingController _dosageFormController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _minStockController;
  late TextEditingController _batchNoController;
  late TextEditingController _qtyController; 
  late TextEditingController _unitPurchasePriceController; 
  late TextEditingController _unitSalePriceController; 
  late TextEditingController _baseUnitNameController;

  // Multi-unit controllers
  final List<TextEditingController> _unitNameControllers = [];
  final List<TextEditingController> _unitFactorControllers = [];
  final List<TextEditingController> _unitPriceControllers = [];
  late FocusNode _nameFocusNode;

  // Custom Fields
  List<CustomFieldDefinition> _customFields = [];
  final Map<int, TextEditingController> _customFieldControllers = {};
  final Map<int, bool> _customFieldCheckboxValues = {};
  final Map<int, String> _customFieldDropdownValues = {};

  // Visibility Settings
  bool _showBrand = true;
  bool _showModel = false;
  bool _showGenericName = false;
  bool _showStrength = false;
  bool _showDosageForm = false;
  bool _showSKU = true;
  bool _showBarcode = true;
  bool _showCategory = true;
  bool _showSubCategory = true;
  bool _showMinStock = true;
  bool _enableBatch = true;
  bool _enableExpiry = true;
  bool _enableMultiUnit = false;
  bool _showPurchasePrice = true;

  // Requirement Settings
  bool _reqName = true;
  bool _reqBrand = false;
  bool _reqModel = false;
  bool _reqGeneric = false;
  bool _reqStrength = false;
  bool _reqDosage = false;
  bool _reqSKU = false;
  bool _reqBarcode = false;
  bool _reqCategory = false;
  bool _reqSubCategory = false;
  bool _reqBatch = false;
  bool _reqExpiry = false;
  bool _reqStock = false;

  String? _selectedMainCategory;
  String? _selectedSubCategory;
  Map<String, List<String>> _categories = {};
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  List<Medicine> _allMedicines = [];
  Medicine? _selectedExistingMedicine;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.name ?? '');
    _brandController = TextEditingController(text: widget.medicine?.brand ?? widget.medicine?.manufacturer ?? '');
    _modelController = TextEditingController(text: widget.medicine?.model ?? '');
    _genericNameController = TextEditingController(text: widget.medicine?.genericName ?? '');
    _strengthController = TextEditingController(text: widget.medicine?.strength ?? '');
    _dosageFormController = TextEditingController(text: widget.medicine?.dosageForm ?? '');
    _skuController = TextEditingController(text: widget.medicine?.code ?? '');
    _barcodeController = TextEditingController(text: widget.medicine?.code ?? '');
    _minStockController = TextEditingController(text: widget.medicine?.minStock.toString() ?? '10');
    _batchNoController = TextEditingController();
    _qtyController = TextEditingController();
    _unitPurchasePriceController = TextEditingController();
    _unitSalePriceController = TextEditingController();
    _baseUnitNameController = TextEditingController(text: widget.medicine?.baseUnitName ?? 'Unit');
    _nameFocusNode = FocusNode();

    if (widget.medicine != null) {
      _selectedMainCategory = widget.medicine!.mainCategory;
      _selectedSubCategory = widget.medicine!.subCategory;
    }
    _selectedExistingMedicine = widget.medicine;
    
    _initializeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _genericNameController.dispose();
    _strengthController.dispose();
    _dosageFormController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _minStockController.dispose();
    _batchNoController.dispose();
    _qtyController.dispose();
    _unitPurchasePriceController.dispose();
    _unitSalePriceController.dispose();
    _baseUnitNameController.dispose();
    _nameFocusNode.dispose();
    for (var c in _unitNameControllers) { c.dispose(); }
    for (var c in _unitFactorControllers) { c.dispose(); }
    for (var c in _unitPriceControllers) { c.dispose(); }
    for (var c in _customFieldControllers.values) { c.dispose(); }
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _loadSettings();
    await _loadCategories();
    await _loadCustomFields();
    if (widget.medicine == null) {
      await _loadLastCategory();
      await _loadAllMedicines();
    } else {
      await _loadProductUnits();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    final showBrand = await repo.getSetting('form_show_brand');
    final showModel = await repo.getSetting('form_show_model');
    final showGeneric = await repo.getSetting('form_show_generic_name');
    final showStrength = await repo.getSetting('form_show_strength');
    final showDosage = await repo.getSetting('form_show_dosage_form');
    final showSKU = await repo.getSetting('form_show_sku');
    final showBarcode = await repo.getSetting('form_show_barcode');
    final showCat = await repo.getSetting('form_show_category');
    final showSub = await repo.getSetting('form_show_sub_category');
    final showMin = await repo.getSetting('form_show_min_stock');
    final enableBatch = await repo.getSetting('inv_enable_batch');
    final enableExpiry = await repo.getSetting('inv_enable_expiry');
    final multiUnit = await repo.getSetting('inv_multi_unit');
    final showBuy = await repo.getSetting('form_show_purchase_price');

    if (mounted) {
      setState(() {
        _showBrand = showBrand != 'false';
        _showModel = showModel == 'true';
        _showGenericName = showGeneric == 'true';
        _showStrength = showStrength == 'true';
        _showDosageForm = showDosage == 'true';
        _showSKU = showSKU != 'false';
        _showBarcode = showBarcode != 'false';
        _showCategory = showCat != 'false';
        _showSubCategory = showSub != 'false';
        _showMinStock = showMin != 'false';
        _enableBatch = enableBatch != 'false';
        _enableExpiry = enableExpiry != 'false';
        _enableMultiUnit = multiUnit == 'true';
        _showPurchasePrice = showBuy != 'false';
      });
    }

    final reqName = await repo.getSetting('form_req_name');
    final reqBrand = await repo.getSetting('form_req_brand');
    final reqModel = await repo.getSetting('form_req_model');
    final reqGeneric = await repo.getSetting('form_req_generic');
    final reqStrength = await repo.getSetting('form_req_strength');
    final reqDosage = await repo.getSetting('form_req_dosage');
    final reqSKU = await repo.getSetting('form_req_sku');
    final reqBarcode = await repo.getSetting('form_req_barcode');
    final reqCategory = await repo.getSetting('form_req_category');
    final reqSubCat = await repo.getSetting('form_req_sub_category');
    final reqBatch = await repo.getSetting('form_req_batch');
    final reqExpiry = await repo.getSetting('form_req_expiry');
    final reqStock = await repo.getSetting('form_req_stock');

    if (mounted) {
      setState(() {
        _reqName = reqName != 'false';
        _reqBrand = reqBrand == 'true';
        _reqModel = reqModel == 'true';
        _reqGeneric = reqGeneric == 'true';
        _reqStrength = reqStrength == 'true';
        _reqDosage = reqDosage == 'true';
        _reqSKU = reqSKU == 'true';
        _reqBarcode = reqBarcode == 'true';
        _reqCategory = reqCategory == 'true';
        _reqSubCategory = reqSubCat == 'true';
        _reqBatch = reqBatch == 'true';
        _reqExpiry = reqExpiry == 'true';
        _reqStock = reqStock == 'true';
      });
    }
  }

  Future<void> _loadProductUnits() async {
    if (widget.medicine == null) return;
    final units = await ref.read(medicineRepositoryProvider).getProductUnits(widget.medicine!.id);
    if (mounted) {
      setState(() {
        for (final unit in units) {
          if (unit.isBaseUnit) {
            _baseUnitNameController.text = unit.name;
          } else {
            _addUnitRow(name: unit.name, factor: unit.conversionFactor, price: unit.salePrice);
          }
        }
      });
    }
  }

  void _addUnitRow({String name = '', double factor = 1.0, double price = 0.0}) {
    _unitNameControllers.add(TextEditingController(text: name));
    _unitFactorControllers.add(TextEditingController(text: factor.toString()));
    _unitPriceControllers.add(TextEditingController(text: price.toString()));
  }

  Future<void> _loadCategories() async {
    final cats = await ref.read(categoryRepositoryProvider).getCategoriesAsMap();
    if (mounted) setState(() => _categories = cats);
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

  Future<void> _loadCustomFields() async {
    final repo = ref.read(settingsRepositoryProvider);
    final bizType = await repo.getSetting('inv_business_type') ?? 'General';
    final customFields = await ref.read(customFieldServiceProvider).getActiveProductFields(bizType);
    
    Map<int, String> existingValues = {};
    if (widget.medicine != null) {
      final values = await ref.read(customFieldServiceProvider).getValues('product', widget.medicine!.id);
      for (final v in values) {
         existingValues[v.definitionId] = v.valueText ?? v.valueNumber?.toString() ?? (v.valueBool == true ? 'true' : 'false');
      }
    }

    if (mounted) {
       setState(() {
          _customFields = customFields.where((f) => f.showInProductForm).toList();
          for (final f in _customFields) {
             if (f.fieldType == 'checkbox') {
                _customFieldCheckboxValues[f.id] = existingValues[f.id] == 'true';
             } else if (f.fieldType == 'dropdown') {
                _customFieldDropdownValues[f.id] = existingValues[f.id] ?? '';
             } else {
                _customFieldControllers[f.id] = TextEditingController(text: existingValues[f.id] ?? '');
             }
          }
       });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(medicineRepositoryProvider);
      final sRepo = ref.read(settingsRepositoryProvider);
      final customService = ref.read(customFieldServiceProvider);

      // Validate Custom Fields
      Map<int, String?> customFormValues = {};
      for (final f in _customFields) {
        if (f.fieldType == 'checkbox') customFormValues[f.id] = _customFieldCheckboxValues[f.id]! ? 'true' : 'false';
        else if (f.fieldType == 'dropdown') customFormValues[f.id] = _customFieldDropdownValues[f.id];
        else customFormValues[f.id] = _customFieldControllers[f.id]?.text;
      }
      
      final error = customService.validateRequiredFields(_customFields, customFormValues);
      if (error != null) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppTheme.redDanger));
         return;
      }
      
      // Built-in Validation
      String? builtInError;
      if (_reqName && _nameController.text.trim().isEmpty) builtInError = 'Product Name is required';
      else if (_showBrand && _reqBrand && _brandController.text.trim().isEmpty) builtInError = 'Brand is required';
      else if (_showModel && _reqModel && _modelController.text.trim().isEmpty) builtInError = 'Model is required';
      else if (_showGenericName && _reqGeneric && _genericNameController.text.trim().isEmpty) builtInError = 'Generic Name is required';
      else if (_showStrength && _reqStrength && _strengthController.text.trim().isEmpty) builtInError = 'Strength is required';
      else if (_showDosageForm && _reqDosage && _dosageFormController.text.trim().isEmpty) builtInError = 'Dosage Form is required';
      else if (_showSKU && _reqSKU && _skuController.text.trim().isEmpty) builtInError = 'SKU is required';
      else if (_showBarcode && _reqBarcode && _barcodeController.text.trim().isEmpty) builtInError = 'Barcode is required';
      else if (_showCategory && _reqCategory && _selectedMainCategory == null) builtInError = 'Category is required';
      else if (_showSubCategory && _reqSubCategory && _selectedSubCategory == null) builtInError = 'Sub-Category is required';
      else if (_enableBatch && _reqBatch && _batchNoController.text.trim().isEmpty) builtInError = 'Batch Number is required';
      else if (_reqStock && _qtyController.text.trim().isEmpty) builtInError = 'Opening Stock is required';
      // _expiryDate is non-null due to DateTime picker. It defaults to +365 days.

      if (builtInError != null) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(builtInError), backgroundColor: AppTheme.redDanger));
         return;
      }
      
      if (_selectedMainCategory != null) await sRepo.saveSetting('last_main_category', _selectedMainCategory!);
      if (_selectedSubCategory != null) await sRepo.saveSetting('last_sub_category', _selectedSubCategory!);

      final mid = await repo.upsertMedicine(MedicinesCompanion(
        id: widget.medicine != null ? drift.Value(widget.medicine!.id) : const drift.Value.absent(),
        name: drift.Value(_nameController.text.trim().isEmpty ? 'Unnamed Product' : _nameController.text.trim()),
        mainCategory: drift.Value(_selectedMainCategory ?? 'Uncategorized'),
        subCategory: drift.Value(_selectedSubCategory),
        brand: drift.Value(_brandController.text),
        model: drift.Value(_modelController.text),
        genericName: drift.Value(_genericNameController.text),
        strength: drift.Value(_strengthController.text),
        dosageForm: drift.Value(_dosageFormController.text),
        minStock: drift.Value(int.tryParse(_minStockController.text) ?? 0),
        code: drift.Value(_barcodeController.text.isNotEmpty ? _barcodeController.text : _skuController.text.isNotEmpty ? _skuController.text : DateTime.now().millisecondsSinceEpoch.toString()),
        baseUnitName: drift.Value(_baseUnitNameController.text.isEmpty ? 'Piece' : _baseUnitNameController.text),
      ));

      // Handle Units
      await repo.deleteProductUnits(mid);
      // Add Base Unit
      await repo.addProductUnit(ProductUnitsCompanion(
        medicineId: drift.Value(mid),
        name: drift.Value(_baseUnitNameController.text),
        conversionFactor: const drift.Value(1.0),
        salePrice: drift.Value(double.tryParse(_unitSalePriceController.text) ?? 0.0),
        isBaseUnit: const drift.Value(true),
        isDefaultSaleUnit: const drift.Value(true),
      ));
      
      if (_enableMultiUnit) {
        for (int i = 0; i < _unitNameControllers.length; i++) {
          if (_unitNameControllers[i].text.isNotEmpty) {
            await repo.addProductUnit(ProductUnitsCompanion(
              medicineId: drift.Value(mid),
              name: drift.Value(_unitNameControllers[i].text),
              conversionFactor: drift.Value(double.tryParse(_unitFactorControllers[i].text) ?? 1.0),
              salePrice: drift.Value(double.tryParse(_unitPriceControllers[i].text) ?? 0.0),
              isBaseUnit: const drift.Value(false),
              isDefaultSaleUnit: const drift.Value(false),
            ));
          }
        }
      }

      // Handle Stock — always create a batch entry when opening stock > 0
      final fQty = int.tryParse(_qtyController.text) ?? 0;
      if (fQty > 0 || widget.medicine == null) {
        // bNo: use user-entered batch if batch tracking is on, else auto-generate
        final rawBatch = _batchNoController.text.trim();
        final bNo = _enableBatch
            ? (rawBatch.isNotEmpty ? rawBatch : 'B-${DateTime.now().millisecondsSinceEpoch}')
            : 'STOCK-ENTRY';
        if (fQty > 0) {
          await repo.addBatch(BatchesCompanion(
            medicineId: drift.Value(mid),
            batchNumber: drift.Value(bNo),
            quantity: drift.Value(fQty),
            purchasePrice: drift.Value(double.tryParse(_unitPurchasePriceController.text) ?? 0.0),
            salePrice: drift.Value(double.tryParse(_unitSalePriceController.text) ?? 0.0),
            // DateTime(2099) is the sentinel for "no expiry". Use isDummyExpiry() when reading back.
            expiryDate: drift.Value(_enableExpiry ? _expiryDate : DateTime(2099, 12, 31)),
          ));
        }
      }

      // Save custom fields
      Map<int, CustomFieldValuesCompanion> cv = {};
      for (final f in _customFields) {
         final val = customFormValues[f.id];
         if (val != null && val.isNotEmpty) {
            cv[f.id] = CustomFieldValuesCompanion.insert(
               definitionId: f.id,
               securityKey: '', // Filled by service
               entityType: 'product',
               entityId: mid,
               valueText: drift.Value(f.fieldType == 'text' || f.fieldType == 'textarea' || f.fieldType == 'dropdown' ? val : null),
               valueNumber: drift.Value(f.fieldType == 'number' || f.fieldType == 'decimal' ? double.tryParse(val) : null),
               valueBool: drift.Value(f.fieldType == 'checkbox' ? val == 'true' : null),
            );
         }
      }
      await customService.saveProductValues(mid, cv);

      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 900,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        color: AppTheme.surface,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIdentitySection(),
                      const SizedBox(height: 32),
                      _buildOrganizationSection(),
                      const SizedBox(height: 32),
                      _buildPricingAndStockSection(),
                      if (_enableMultiUnit) ...[
                        const SizedBox(height: 32),
                        _buildMultiUnitSection(),
                      ],
                      if (_customFields.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildCustomFieldsSection(),
                      ],
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Text(widget.medicine == null ? 'New Product Enrollment' : 'Update Product Details', 
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close_rounded, color: Colors.white70), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildIdentitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Product Identity'),
        const SizedBox(height: 16),
        _buildNameField(),
        const SizedBox(height: 16),
        Row(
          children: [
            if (_showBrand) Expanded(child: _buildTextField(_brandController, 'Brand / Manufacturer', Icons.factory_rounded)),
            if (_showBrand && _showModel) const SizedBox(width: 16),
            if (_showModel) Expanded(child: _buildTextField(_modelController, 'Model / Version', Icons.style_rounded)),
          ],
        ),
        if (_showGenericName || _showStrength || _showDosageForm) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              if (_showGenericName) Expanded(child: _buildTextField(_genericNameController, 'Generic Name', Icons.science_rounded)),
              if (_showGenericName && (_showStrength || _showDosageForm)) const SizedBox(width: 16),
              if (_showStrength) Expanded(child: _buildTextField(_strengthController, 'Strength', Icons.bolt_rounded)),
              if (_showStrength && _showDosageForm) const SizedBox(width: 16),
              if (_showDosageForm) Expanded(child: _buildTextField(_dosageFormController, 'Dosage Form', Icons.medication_rounded)),
            ],
          ),
        ],
        if (_showSKU || _showBarcode) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              if (_showSKU) Expanded(child: _buildTextField(_skuController, 'SKU / Internal Code', Icons.qr_code_rounded)),
              if (_showSKU && _showBarcode) const SizedBox(width: 16),
              if (_showBarcode) Expanded(child: _buildTextField(_barcodeController, 'Barcode', Icons.barcode_reader)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOrganizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Organization'),
        const SizedBox(height: 16),
        Row(
          children: [
            if (_showCategory) Expanded(child: _buildDropdown('Main Category', _selectedMainCategory, _categories.keys.toList(), (v) => setState(() { _selectedMainCategory = v; _selectedSubCategory = null; }))),
            if (_showCategory && _showSubCategory) const SizedBox(width: 16),
            if (_showSubCategory) Expanded(child: _buildDropdown('Sub Category', _selectedSubCategory, _selectedMainCategory == null ? [] : (_categories[_selectedMainCategory!] ?? []), (v) => setState(() => _selectedSubCategory = v))),
            if (_showSubCategory && _showMinStock) const SizedBox(width: 16),
            if (_showMinStock) Expanded(child: _buildTextField(_minStockController, 'Min Stock Alert', Icons.warning_amber_rounded, isNumeric: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingAndStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Pricing & Opening Stock'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r16), border: Border.all(color: AppTheme.border)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextField(_baseUnitNameController, 'Base Unit (e.g. Piece)', Icons.extension_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_qtyController, 'Initial Quantity', Icons.inventory_rounded, isNumeric: true)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_showPurchasePrice) Expanded(child: _buildTextField(_unitPurchasePriceController, 'Purchase Price', Icons.shopping_bag_rounded, isNumeric: true)),
                  if (_showPurchasePrice) const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_unitSalePriceController, 'Sale Price', Icons.sell_rounded, isNumeric: true)),
                ],
              ),
              if (_enableBatch || _enableExpiry) ...[
                const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                Row(
                  children: [
                    if (_enableBatch) Expanded(child: _buildTextField(_batchNoController, 'Batch Number', Icons.numbers_rounded)),
                    if (_enableBatch && _enableExpiry) const SizedBox(width: 16),
                    if (_enableExpiry) Expanded(child: _buildDatePicker()),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultiUnitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Additional Sale Units'),
            TextButton.icon(
              onPressed: () => setState(() => _addUnitRow()),
              icon: const Icon(Icons.add_rounded),
              label: const Text('ADD UNIT'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Define conversion factors to the base unit (e.g. 1 Strip = 10 Tablets)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 16),
        if (_unitNameControllers.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No additional units defined', style: TextStyle(color: AppTheme.textMuted))))
        else
          ...List.generate(_unitNameControllers.length, (i) => _buildUnitRow(i)),
      ],
    );
  }

  Widget _buildUnitRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildTextField(_unitNameControllers[index], 'Unit Name (e.g. Strip)', Icons.label_rounded)),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _buildTextField(_unitFactorControllers[index], 'Conversion Factor', Icons.multiple_stop_rounded, isNumeric: true)),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _buildTextField(_unitPriceControllers[index], 'Unit Price', Icons.payments_rounded, isNumeric: true)),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline_rounded, color: AppTheme.redDanger),
            onPressed: () => setState(() {
              _unitNameControllers.removeAt(index);
              _unitFactorControllers.removeAt(index);
              _unitPriceControllers.removeAt(index);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
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
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.primaryNavy));

  Widget _buildNameField() {
    return LayoutBuilder(builder: (context, c) {
      return RawAutocomplete<Medicine>(
        textEditingController: _nameController,
        focusNode: _nameFocusNode,
        optionsBuilder: (v) => v.text.isEmpty ? const Iterable<Medicine>.empty() : _allMedicines.where((m) => m.name.toLowerCase().contains(v.text.toLowerCase())),
        displayStringForOption: (m) => m.name,
        onSelected: (m) => setState(() {
          _selectedExistingMedicine = m;
          _nameController.text = m.name;
          _brandController.text = m.brand ?? m.manufacturer ?? '';
          _modelController.text = m.model ?? '';
          _genericNameController.text = m.genericName ?? '';
          _strengthController.text = m.strength ?? '';
          _dosageFormController.text = m.dosageForm ?? '';
          _skuController.text = m.code;
          _minStockController.text = m.minStock.toString();
          _selectedMainCategory = m.mainCategory;
          _selectedSubCategory = m.subCategory;
          _baseUnitNameController.text = m.baseUnitName;
        }),
        fieldViewBuilder: (ctx, ctrl, focus, onSub) => TextFormField(
          controller: ctrl, focusNode: focus,
          decoration: const InputDecoration(labelText: 'Product Name', prefixIcon: Icon(Icons.search_rounded)),
          validator: (v) => null,
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
      keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), fillColor: readOnly ? AppTheme.surfaceVariant : Colors.white, filled: true),
      validator: (v) => !readOnly && isNumeric && (v == null || v.isEmpty) ? null : null, // Not strictly required for all fields
    );
  }

  Widget _buildDropdown(String label, String? val, List<String> items, ValueChanged<String?> onChg) {
    return DropdownButtonFormField<String>(
      value: val, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChg, decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.layers_rounded, size: 20), fillColor: Colors.white, filled: true),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: _expiryDate, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 3650)));
        if (d != null) setState(() => _expiryDate = d);
      },
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Expiry Date', prefixIcon: Icon(Icons.event_rounded, size: 20), fillColor: Colors.white, filled: true),
        child: Text(DateFormat('MMM dd, yyyy').format(_expiryDate), style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildCustomFieldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Additional Business Attributes'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _customFields.map((f) {
            const w = 400.0;
            if (f.fieldType == 'checkbox') {
              return SizedBox(
                width: w,
                child: CheckboxListTile(
                  title: Text('${f.fieldLabel}${f.isRequired ? ' *' : ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  value: _customFieldCheckboxValues[f.id] ?? false,
                  onChanged: (v) => setState(() => _customFieldCheckboxValues[f.id] = v!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            } else if (f.fieldType == 'dropdown') {
              List<String> options = [];
              if (f.optionsJson != null) {
                try {
                  final List<dynamic> decoded = jsonDecode(f.optionsJson!);
                  options = decoded.map((e) => e.toString()).toList();
                } catch (_) {}
              }
              return SizedBox(
                width: w,
                child: _buildDropdown(
                  '${f.fieldLabel}${f.isRequired ? ' *' : ''}',
                  _customFieldDropdownValues[f.id]?.isEmpty == true ? null : _customFieldDropdownValues[f.id],
                  options,
                  (v) => setState(() => _customFieldDropdownValues[f.id] = v ?? ''),
                ),
              );
            } else {
              return SizedBox(
                width: w,
                child: _buildTextField(
                  _customFieldControllers[f.id]!,
                  '${f.fieldLabel}${f.isRequired ? ' *' : ''}',
                  Icons.text_fields_rounded,
                  isNumeric: f.fieldType == 'number' || f.fieldType == 'decimal',
                ),
              );
            }
          }).toList(),
        ),
      ],
    );
  }
}

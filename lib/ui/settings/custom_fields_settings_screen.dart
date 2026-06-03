import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/database/database.dart';
import '../../data/repositories/custom_field_repository.dart';
import '../../data/providers/current_shop_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../shared/app_theme.dart';

class CustomFieldsSettingsScreen extends ConsumerStatefulWidget {
  const CustomFieldsSettingsScreen({super.key});

  @override
  ConsumerState<CustomFieldsSettingsScreen> createState() => _CustomFieldsSettingsScreenState();
}

class _CustomFieldsSettingsScreenState extends ConsumerState<CustomFieldsSettingsScreen> {
  bool _isLoading = true;
  List<CustomFieldDefinition> _fields = [];
  String? _securityKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFields());
  }

  Future<void> _loadFields() async {
    setState(() => _isLoading = true);
    _securityKey = ref.read(currentShopProvider)?['securityKey'] as String?;
    if (_securityKey == null) return;
    
    final repo = ref.read(customFieldRepositoryProvider);
    final fields = await repo.getAllDefinitions(_securityKey!);
    setState(() {
      _fields = fields;
      _isLoading = false;
    });
  }

  void _openEditDialog([CustomFieldDefinition? field]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CustomFieldEditDialog(
        securityKey: _securityKey!,
        initialField: field,
        onSaved: _loadFields,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Fields Configuration'),
        backgroundColor: AppTheme.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fields.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.table_chart_outlined, size: 64, color: AppTheme.textMuted),
                      const SizedBox(height: 16),
                      const Text('No Custom Fields Defined', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Create Field'),
                        onPressed: _openEditDialog,
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _fields.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final f = _fields[index];
                    return ListTile(
                      leading: Icon(
                        f.fieldType == 'dropdown' ? Icons.arrow_drop_down_circle :
                        f.fieldType == 'checkbox' ? Icons.check_box :
                        f.fieldType == 'number' || f.fieldType == 'decimal' ? Icons.numbers :
                        Icons.text_fields,
                        color: f.isActive ? AppTheme.royalBlue : AppTheme.textMuted,
                      ),
                      title: Text(f.fieldLabel, style: TextStyle(fontWeight: FontWeight.w600, color: f.isActive ? Colors.black : Colors.grey)),
                      subtitle: Text('${f.entityType} • ${f.fieldType}${f.isRequired ? ' • Required' : ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: f.isActive,
                            onChanged: (val) async {
                              final updated = CustomFieldDefinitionsCompanion.insert(
                                id: drift.Value(f.id),
                                securityKey: f.securityKey,
                                entityType: f.entityType,
                                fieldKey: f.fieldKey,
                                fieldLabel: f.fieldLabel,
                                fieldType: f.fieldType,
                                isActive: drift.Value(val),
                                isRequired: drift.Value(f.isRequired),
                                showInProductForm: drift.Value(f.showInProductForm),
                                showInPOS: drift.Value(f.showInPOS),
                                showInCart: drift.Value(f.showInCart),
                                showInInvoice: drift.Value(f.showInInvoice),
                                showInSearch: drift.Value(f.showInSearch),
                                showInReports: drift.Value(f.showInReports),
                                businessType: drift.Value(f.businessType),
                                optionsJson: drift.Value(f.optionsJson),
                                sortOrder: drift.Value(f.sortOrder),
                                createdAt: drift.Value(f.createdAt),
                                updatedAt: drift.Value(DateTime.now()),
                              );
                              await ref.read(customFieldRepositoryProvider).updateDefinition(updated);
                              _loadFields();
                            },
                          ),
                          IconButton(icon: const Icon(Icons.edit, color: AppTheme.textSecondary), onPressed: () => _openEditDialog(f)),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Field'),
        backgroundColor: AppTheme.royalBlue,
      ),
    );
  }
}

class _CustomFieldEditDialog extends ConsumerStatefulWidget {
  final String securityKey;
  final CustomFieldDefinition? initialField;
  final VoidCallback onSaved;

  const _CustomFieldEditDialog({required this.securityKey, this.initialField, required this.onSaved});

  @override
  ConsumerState<_CustomFieldEditDialog> createState() => _CustomFieldEditDialogState();
}

class _CustomFieldEditDialogState extends ConsumerState<_CustomFieldEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _keyController;
  late TextEditingController _optionsController;
  
  String _entityType = 'product';
  String _fieldType = 'text';
  bool _isRequired = false;
  bool _showInForm = true;
  bool _showInPOS = false;
  bool _showInCart = false;
  bool _showInInvoice = false;
  bool _showInSearch = false;
  
  @override
  void initState() {
    super.initState();
    final f = widget.initialField;
    _labelController = TextEditingController(text: f?.fieldLabel ?? '');
    _keyController = TextEditingController(text: f?.fieldKey ?? '');
    _optionsController = TextEditingController(text: f?.optionsJson != null ? List<String>.from(jsonDecode(f!.optionsJson!)).join(', ') : '');
    
    if (f != null) {
      _entityType = f.entityType;
      _fieldType = f.fieldType;
      _isRequired = f.isRequired;
      _showInForm = f.showInProductForm;
      _showInPOS = f.showInPOS;
      _showInCart = f.showInCart;
      _showInInvoice = f.showInInvoice;
      _showInSearch = f.showInSearch;
    }
  }

  void _generateKey(String val) {
    if (widget.initialField == null) {
      _keyController.text = val.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    String? optionsJson;
    if (_fieldType == 'dropdown') {
      final opts = _optionsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (opts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dropdown requires at least one option')));
        return;
      }
      optionsJson = jsonEncode(opts);
    }

    final bizType = await ref.read(settingsRepositoryProvider).getSetting('inv_business_type') ?? 'General';
    final now = DateTime.now();

    final companion = CustomFieldDefinitionsCompanion.insert(
      id: widget.initialField == null ? const drift.Value.absent() : drift.Value(widget.initialField!.id),
      securityKey: widget.securityKey,
      businessType: drift.Value(bizType),
      entityType: _entityType,
      fieldKey: _keyController.text,
      fieldLabel: _labelController.text,
      fieldType: _fieldType,
      optionsJson: drift.Value(optionsJson),
      isRequired: drift.Value(_isRequired),
      isActive: drift.Value(widget.initialField?.isActive ?? true),
      showInProductForm: drift.Value(_showInForm),
      showInPOS: drift.Value(_showInPOS),
      showInCart: drift.Value(_showInCart),
      showInInvoice: drift.Value(_showInInvoice),
      showInSearch: drift.Value(_showInSearch),
      showInReports: const drift.Value(true),
      createdAt: widget.initialField == null ? drift.Value(now) : drift.Value(widget.initialField!.createdAt),
      updatedAt: drift.Value(now),
    );

    if (widget.initialField == null) {
      await ref.read(customFieldRepositoryProvider).saveDefinition(companion);
    } else {
      await ref.read(customFieldRepositoryProvider).updateDefinition(companion);
    }

    if (mounted) {
      Navigator.pop(context);
      widget.onSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(widget.initialField == null ? 'New Custom Field' : 'Edit Custom Field', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Field Label (e.g. Rack No)'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onChanged: _generateKey,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keyController,
                decoration: const InputDecoration(labelText: 'Field Key (Internal)'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                enabled: widget.initialField == null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fieldType,
                decoration: const InputDecoration(labelText: 'Field Type'),
                items: const [
                  DropdownMenuItem(value: 'text', child: Text('Text')),
                  DropdownMenuItem(value: 'number', child: Text('Number')),
                  DropdownMenuItem(value: 'decimal', child: Text('Decimal')),
                  DropdownMenuItem(value: 'date', child: Text('Date')),
                  DropdownMenuItem(value: 'dropdown', child: Text('Dropdown')),
                  DropdownMenuItem(value: 'checkbox', child: Text('Checkbox')),
                  DropdownMenuItem(value: 'textarea', child: Text('Multi-line Text')),
                ],
                onChanged: (v) => setState(() => _fieldType = v!),
              ),
              if (_fieldType == 'dropdown') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _optionsController,
                  decoration: const InputDecoration(labelText: 'Options (comma separated)'),
                ),
              ],
              const SizedBox(height: 20),
              const Text('Visibility & Validation', style: TextStyle(fontWeight: FontWeight.bold)),
              SwitchListTile(title: const Text('Required Field'), value: _isRequired, onChanged: (v) => setState(() => _isRequired = v)),
              SwitchListTile(title: const Text('Show in Product Form'), value: _showInForm, onChanged: (v) => setState(() => _showInForm = v)),
              SwitchListTile(title: const Text('Show in POS Table/Card'), value: _showInPOS, onChanged: (v) => setState(() => _showInPOS = v)),
              SwitchListTile(title: const Text('Show in Cart'), value: _showInCart, onChanged: (v) => setState(() => _showInCart = v)),
              SwitchListTile(title: const Text('Show in Invoice/Bill'), value: _showInInvoice, onChanged: (v) => setState(() => _showInInvoice = v)),
              SwitchListTile(title: const Text('Searchable in POS'), value: _showInSearch, onChanged: (v) => setState(() => _showInSearch = v)),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.royalBlue, foregroundColor: Colors.white), child: const Text('Save Field')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

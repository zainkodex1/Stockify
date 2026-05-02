import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';

class CustomerEntryDialog extends ConsumerStatefulWidget {
  final Customer? initialCustomer;
  final String? initialName;
  const CustomerEntryDialog({super.key, this.initialCustomer, this.initialName});

  @override
  ConsumerState<CustomerEntryDialog> createState() => _CustomerEntryDialogState();
}

class _CustomerEntryDialogState extends ConsumerState<CustomerEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  bool _isSearching = false;
  List<Customer> _searchResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCustomer != null) {
      _nameController.text = widget.initialCustomer!.name;
      _phoneController.text = widget.initialCustomer!.phoneNumber ?? '';
    } else if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialName != null && widget.initialName!.isNotEmpty) {
        _phoneFocus.requestFocus();
      } else {
        _nameFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  Future<void> _searchCustomers(String query) async {
    if (query.isEmpty) { setState(() { _isSearching = false; _searchResults = []; }); return; }
    setState(() => _isSearching = true);
    final results = await ref.read(customerRepositoryProvider).searchCustomers(query);
    setState(() { _searchResults = results; _isSearching = false; });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final customer = await ref.read(customerRepositoryProvider).createOrGetCustomer(
      _nameController.text.trim(),
      _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
    );
    if (context.mounted) Navigator.pop(context, customer);
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const _SubmitIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _CancelIntent(),
      },
      child: Actions(
        actions: {
          _SubmitIntent: CallbackAction<_SubmitIntent>(onInvoke: (_) => _handleSubmit()),
          _CancelIntent: CallbackAction<_CancelIntent>(onInvoke: (_) => Navigator.pop(context)),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 450,
              color: AppTheme.surface,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
                      child: Row(
                        children: [
                          const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          const Text('Customer Identity', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.close_rounded, color: Colors.white70), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            decoration: const InputDecoration(labelText: 'Customer Full Name *', prefixIcon: Icon(Icons.person_rounded, size: 20)),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                            onChanged: (v) => v.length > 2 ? _searchCustomers(v) : null,
                            onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            decoration: const InputDecoration(labelText: 'Mobile Number (Optional)', prefixIcon: Icon(Icons.phone_rounded, size: 20)),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)],
                            onFieldSubmitted: (_) => _handleSubmit(),
                          ),
                          
                          if (_isSearching)
                            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2))
                          else if (_searchResults.isNotEmpty && _nameController.text.length > 2)
                            _buildSearchResults(),
                          
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.royalBlue, foregroundColor: Colors.white),
                              child: const Text('CONFIRM CUSTOMER (Enter)', style: TextStyle(fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r12), border: Border.all(color: AppTheme.border)),
      constraints: const BoxConstraints(maxHeight: 150),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _searchResults.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = _searchResults[i];
          return ListTile(
            dense: true,
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: c.phoneNumber != null ? Text(c.phoneNumber!) : null,
            onTap: () => Navigator.pop(context, c),
          );
        },
      ),
    );
  }
}

class _SubmitIntent extends Intent { const _SubmitIntent(); }
class _CancelIntent extends Intent { const _CancelIntent(); }

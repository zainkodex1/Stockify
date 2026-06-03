import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/shop_repository.dart';
import '../../data/providers/current_shop_provider.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';
import 'category_management_screen.dart';
import 'pos_settings_screen.dart';
import 'inventory_flow_settings_screen.dart';
import 'custom_fields_settings_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isUpdating = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBusinessData());
  }

  void _loadBusinessData() {
    final businessData = ref.read(currentShopProvider);
    if (businessData != null && !_dataLoaded) {
      setState(() {
        _businessNameController.text = businessData['shopName'] ?? '';
        _ownerNameController.text = businessData['ownerName'] ?? '';
        _addressController.text = businessData['address'] ?? '';
        _phoneController.text = businessData['phone'] ?? '';
        _dataLoaded = true;
      });
    }
  }

  Future<void> _updateBusinessInfo() async {
    final businessData = ref.read(currentShopProvider);
    if (businessData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No business data available'), backgroundColor: AppTheme.redDanger)
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final repo = ref.read(shopRepositoryProvider);
      await repo.updateShopInfo(
        email: businessData['email'] ?? '',
        shopName: _businessNameController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      final updatedData = Map<String, dynamic>.from(businessData);
      updatedData['shopName'] = _businessNameController.text.trim();
      updatedData['ownerName'] = _ownerNameController.text.trim();
      updatedData['phone'] = _phoneController.text.trim();
      updatedData['address'] = _addressController.text.trim();
      ref.read(currentShopProvider.notifier).setShop(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Business information updated!'), backgroundColor: AppTheme.emeraldSuccess)
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.redDanger)
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = ref.watch(userRepositoryProvider);
    final businessData = ref.watch(currentShopProvider);

    if (businessData != null && !_dataLoaded) {
      _loadBusinessData();
    }

    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Section
            _buildSectionHeader('Business Identity'),
            _buildSettingsCard(
              child: Column(
                children: [
                  if (businessData != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.infoSurface,
                        borderRadius: BorderRadius.circular(AppTheme.r12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: AppTheme.royalBlue,
                            child: Icon(Icons.business_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(businessData['shopName'] ?? 'Store Name', 
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                Text(businessData['email'] ?? '', 
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildTextField(_businessNameController, 'Store Name', Icons.business_rounded),
                  const SizedBox(height: 16),
                  _buildTextField(_ownerNameController, 'Owner Full Name', Icons.person_rounded),
                  const SizedBox(height: 16),
                  _buildTextField(_phoneController, 'Contact Number', Icons.phone_rounded),
                  const SizedBox(height: 16),
                  _buildTextField(_addressController, 'Physical Address', Icons.location_on_rounded, maxLines: 2),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isUpdating ? null : _updateBusinessInfo,
                      icon: _isUpdating 
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_rounded, size: 18),
                      label: const Text('SAVE BUSINESS INFO', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.royalBlue, foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            _buildSectionHeader('Application Modules'),
            _buildClickableSetting(
              title: 'Manage Categories',
              subtitle: 'Customize inventory categorization layers',
              icon: Icons.category_rounded,
              color: Colors.purple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagementScreen())),
            ),
            _buildClickableSetting(
              title: 'POS Configuration',
              subtitle: 'Set defaults for taxes, fees, and discounts',
              icon: Icons.point_of_sale_rounded,
              color: AppTheme.royalBlue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PosSettingsScreen())),
            ),
            _buildClickableSetting(
              title: 'Inventory Flow Control',
              subtitle: 'Business presets and dynamic field visibility',
              icon: Icons.edit_note_rounded,
              color: AppTheme.tealAccent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryFlowSettingsScreen())),
            ),
            _buildClickableSetting(
              title: 'Custom Fields Configuration',
              subtitle: 'Define business-specific attributes',
              icon: Icons.format_list_bulleted_add,
              color: AppTheme.emeraldSuccess,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomFieldsSettingsScreen())),
            ),

            const SizedBox(height: 40),
            _buildSectionHeader('Data Integrity'),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                SizedBox(
                  width: 300,
                  child: _buildDataAction(
                    'Backup Data', 
                    'Secure a local snapshot', 
                    Icons.cloud_upload_rounded, 
                    AppTheme.royalBlue, 
                    _backupDatabase
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: _buildDataAction(
                    'Restore Data', 
                    'Load previous snapshots', 
                    Icons.history_rounded, 
                    AppTheme.amberWarning, 
                    _restoreDatabase
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            _buildSectionHeader('User Governance'),
            FutureBuilder<List<User>>(
              future: userRepo.getAllUsers(),
              builder: (context, snapshot) {
                final users = snapshot.data ?? [];
                return _buildSettingsCard(
                  child: Column(
                    children: [
                      if (users.isEmpty) 
                        const Padding(padding: EdgeInsets.all(20), child: Text('No other users configured'))
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.infoSurface,
                                child: Text(user.username[0].toUpperCase(), style: const TextStyle(color: AppTheme.royalBlue, fontWeight: FontWeight.bold)),
                              ),
                              title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(user.role, style: const TextStyle(fontSize: 12)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.redDanger, size: 20),
                                onPressed: () {},
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('REGISTER NEW USER'),
                        onPressed: () => _showAddUserDialog(context, userRepo),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primaryNavy)),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.r20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: child,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildClickableSetting({required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppTheme.r12)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDataAction(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.r16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.r16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Future<void> _backupDatabase() async {
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, 'pharmacy_db.sqlite');
      final dbFile = File(dbPath);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Export System Backup',
        fileName: 'stockify_backup_${intl.DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.sqlite',
      );

      if (outputFile != null) {
        await dbFile.copy(outputFile);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Database backup exported successfully!'),
            backgroundColor: AppTheme.emeraldSuccess,
          ));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup Failed: $e'), backgroundColor: AppTheme.redDanger));
    }
  }

  Future<void> _restoreDatabase() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database restoration logic pending safety validation.')));
  }

  void _showAddUserDialog(BuildContext context, UserRepository userRepo) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String role = 'Cashier';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(usernameController, 'Username', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildTextField(passwordController, 'Password', Icons.lock_outline_rounded),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: role,
              items: ['Admin', 'Manager', 'Cashier'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => role = v!,
              decoration: const InputDecoration(labelText: 'System Role', prefixIcon: Icon(Icons.admin_panel_settings_rounded, size: 20)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                await userRepo.registerUser(usernameController.text, passwordController.text, role);
                if (context.mounted) Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('REGISTER USER'),
          ),
        ],
      ),
    );
  }
}

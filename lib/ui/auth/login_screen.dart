import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/dashboard_screen.dart';
import '../shared/app_theme.dart';
import '../../data/repositories/shop_repository.dart';
import '../../data/providers/current_shop_provider.dart';
import '../../data/services/business_preset_service.dart';
import 'owner_login_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _securityKeyController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final key = _securityKeyController.text.trim();
    
    if (key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your security key'), backgroundColor: AppTheme.redDanger)
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(shopRepositoryProvider);
      final businessData = await repo.getShopBySecurityKey(key);

      if (businessData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Security Key'), backgroundColor: AppTheme.redDanger)
          );
          setState(() => _isLoading = false);
        }
        return;
      }

      // Save to provider
      ref.read(currentShopProvider.notifier).setShop(businessData);

      // Apply and save business preset settings locally
      final rawBusinessType = businessData['businessType'] as String?;
      await ref.read(businessPresetServiceProvider).applyPresetFromBusinessType(rawBusinessType);

      if (mounted) {
        final businessName = businessData['shopName'] ?? 'Business';
        final ownerName = businessData['ownerName'] ?? 'Owner';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Welcome to $businessName, $ownerName!'),
            backgroundColor: AppTheme.emeraldSuccess,
          )
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.redDanger)
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.sidebarGradient,
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 450,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.r20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppTheme.infoSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt_rounded, color: AppTheme.royalBlue, size: 48),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'STOCKIFY',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: AppTheme.primaryNavy,
                        ),
                      ),
                      const Text(
                        'Enterprise POS & Inventory',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Security Key Field
                      TextField(
                        controller: _securityKeyController,
                        decoration: const InputDecoration(
                          labelText: 'Business Security Key',
                          hintText: 'Enter your 6-digit key',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                        ),
                        onSubmitted: (_) => _login(),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.royalBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.r12),
                            ),
                            elevation: 4,
                            shadowColor: AppTheme.royalBlue.withValues(alpha: 0.4),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text(
                                  'SIGN IN',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      const Text(
                        '© 2026 Stockify Solutions. All Rights Reserved.',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Admin Entry Point
            Positioned(
              top: 40,
              right: 40,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.admin_panel_settings, color: AppTheme.tealAccent, size: 28),
                      tooltip: 'Super Admin',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const OwnerLoginScreen()));
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sales/sales_history_screen.dart';
import '../medicines/medicines_screen.dart';
import '../pos/pos_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../auth/login_screen.dart';
import '../shared/app_theme.dart';
import '../../data/providers/current_shop_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<Widget> _screens = [
    const _DashboardHome(),
    const MedicinesScreen(),
    const PosScreen(),
    const SalesHistoryScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  void _navigateToIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: AppTheme.redDanger),
            const SizedBox(width: 12),
            const Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to exit Stockify?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redDanger),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1): _NavigateIntent(0),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2): _NavigateIntent(1),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3): _NavigateIntent(2),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4): _NavigateIntent(3),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit5): _NavigateIntent(4),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit6): _NavigateIntent(5),
      },
      child: Actions(
        actions: {
          _NavigateIntent: CallbackAction<_NavigateIntent>(onInvoke: (intent) {
            _navigateToIndex(intent.index);
            return null;
          }),
        },
        child: Focus(
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              
              if (isDesktop) {
                return Scaffold(
                  body: Row(
                    children: [
                      _Sidebar(
                        selectedIndex: _selectedIndex,
                        onSelectedIndexChanged: _navigateToIndex,
                        isCollapsed: _isSidebarCollapsed,
                        onToggleCollapse: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                        onLogout: () => _showLogoutDialog(context),
                      ),
                      Expanded(
                        child: _screens[_selectedIndex],
                      ),
                    ],
                  ),
                );
              } else {
                return Scaffold(
                  body: _screens[_selectedIndex],
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _navigateToIndex,
                    backgroundColor: AppTheme.surface,
                    indicatorColor: AppTheme.infoSurface,
                    destinations: const [
                      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
                      NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Inventory'),
                      NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale), label: 'POS'),
                      NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Sales'),
                      NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Reports'),
                      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.isCollapsed,
    required this.onToggleCollapse,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isCollapsed ? 80 : 260,
      decoration: const BoxDecoration(
        gradient: AppTheme.sidebarGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Logo Area
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 24),
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.r12),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: AppTheme.tealAccent, size: 28),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 16),
                  const Text(
                    'STOCKIFY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectedIndexChanged(0),
                ),
                _SidebarItem(
                  icon: Icons.inventory_2_rounded,
                  label: 'Inventory',
                  isSelected: selectedIndex == 1,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectedIndexChanged(1),
                ),
                _SidebarItem(
                  icon: Icons.point_of_sale_rounded,
                  label: 'Point of Sale',
                  isSelected: selectedIndex == 2,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectedIndexChanged(2),
                ),
                _SidebarItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'Sales History',
                  isSelected: selectedIndex == 3,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectedIndexChanged(3),
                ),
                _SidebarItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reports',
                  isSelected: selectedIndex == 4,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectedIndexChanged(4),
                ),
                _SidebarItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: selectedIndex == 5,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectedIndexChanged(5),
                ),
              ],
            ),
          ),
          // Footer Area
          _SidebarItem(
            icon: isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
            label: 'Collapse',
            isSelected: false,
            isCollapsed: isCollapsed,
            onTap: onToggleCollapse,
          ),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Logout',
            isSelected: false,
            isCollapsed: isCollapsed,
            onTap: onLogout,
            isLogout: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;
  final bool isLogout;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.r12),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.sidebarActive : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.r12),
              border: isSelected 
                ? const Border(left: BorderSide(color: AppTheme.sidebarActiveBorder, width: 4))
                : null,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    icon,
                    color: isSelected 
                      ? AppTheme.sidebarActiveText 
                      : (isLogout ? AppTheme.redDanger : AppTheme.sidebarText),
                    size: 22,
                  ),
                ),
                if (!isCollapsed)
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected 
                          ? AppTheme.sidebarActiveText 
                          : (isLogout ? AppTheme.redDanger : AppTheme.sidebarText),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHome extends ConsumerWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessData = ref.watch(currentShopProvider);
    final businessName = businessData?['shopName'] ?? 'Stockify';
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium Gradient Header
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
                      ),
                      Text(
                        businessName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(32.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Store Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                
                // Responsive Stats Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    int crossAxisCount = width > 1200 ? 4 : (width > 800 ? 2 : 1);
                    
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      shrinkWrap: true,
                      childAspectRatio: 1.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStatCard(
                          context, 
                          'Total Sales', 
                          'PKR 25,400', 
                          Icons.payments_rounded, 
                          AppTheme.royalBlue,
                        ),
                        _buildStatCard(
                          context, 
                          'Low Stock', 
                          '12 Items', 
                          Icons.inventory_2_rounded, 
                          AppTheme.redDanger,
                          isWarning: true,
                        ),
                        _buildStatCard(
                          context, 
                          'Active Customers', 
                          '48', 
                          Icons.people_alt_rounded, 
                          AppTheme.tealAccent,
                        ),
                        _buildStatCard(
                          context, 
                          'Total Revenue', 
                          'PKR 1.2M', 
                          Icons.trending_up_rounded, 
                          AppTheme.emeraldSuccess,
                        ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 48),
                Text(
                  'Recent Performance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                
                // Analytics Placeholder
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.r20),
                    border: Border.all(color: AppTheme.border),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart_rounded, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        const Text('Sales Analytics Chart Coming Soon', 
                          style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color accentColor, {bool isWarning = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.r20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              icon,
              size: 100,
              color: accentColor.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.r12),
                      ),
                      child: Icon(icon, color: accentColor, size: 24),
                    ),
                    if (isWarning)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.redDanger.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.rPill),
                        ),
                        child: const Text(
                          'Action Required',
                          style: TextStyle(color: AppTheme.redDanger, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Intent class for navigation shortcuts
class _NavigateIntent extends Intent {
  final int index;
  const _NavigateIntent(this.index);
}

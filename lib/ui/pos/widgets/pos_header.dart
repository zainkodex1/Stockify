import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/database.dart';
import '../../../ui/shared/app_theme.dart';
import '../../../data/providers/current_shop_provider.dart';
import '../../../data/repositories/settings_repository.dart';

// ─── Public Widget ─────────────────────────────────────────────────────────────

/// POS top area: slim gradient info bar + two visually-separated cards
/// (Customer  |  Product Search). Same external API as previous version.
class PosHeader extends ConsumerWidget {
  const PosHeader({
    super.key,
    required this.isMobile,
    required this.customerNameController,
    required this.customerPhoneController,
    required this.customerNameFocus,
    required this.customerSearchResults,
    required this.onSearchCustomers,
    required this.onSelectCustomer,
    required this.onNewCustomer,
    required this.searchQuery,
    required this.productSearchController,
    required this.productSearchFocus,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onNewSale,
    this.onClearCustomer,
  });

  final bool isMobile;
  final TextEditingController customerNameController;
  final TextEditingController customerPhoneController;
  final FocusNode customerNameFocus;
  final List<Customer> customerSearchResults;
  final ValueChanged<String> onSearchCustomers;
  final ValueChanged<Customer> onSelectCustomer;
  final Function([String? name]) onNewCustomer;
  final String searchQuery;
  final TextEditingController productSearchController;
  final FocusNode productSearchFocus;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onNewSale;
  final VoidCallback? onClearCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessData = ref.watch(currentShopProvider);
    final shopName = businessData?['shopName'] ?? 'Stockify';
    final userName = businessData?['ownerName'] ?? 'Cashier';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SlimInfoBar(
          isMobile: isMobile,
          shopName: shopName,
          userName: userName,
          onNewSale: onNewSale,
        ),
        _ControlStrip(
          isMobile: isMobile,
          customerController: customerNameController,
          customerFocus: customerNameFocus,
          customerResults: customerSearchResults,
          onSearchCustomer: onSearchCustomers,
          onSelectCustomer: onSelectCustomer,
          onNewCustomer: onNewCustomer,
          productController: productSearchController,
          productFocus: productSearchFocus,
          onProductSearchChanged: onSearchChanged,
          onClearProduct: onClearSearch,
          onClearCustomer: onClearCustomer,
        ),
      ],
    );
  }
}

// ─── Slim Gradient Info Bar ───────────────────────────────────────────────────

class _SlimInfoBar extends StatelessWidget {
  const _SlimInfoBar({
    required this.isMobile,
    required this.shopName,
    required this.userName,
    required this.onNewSale,
  });

  final bool isMobile;
  final String shopName;
  final String userName;
  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!isMobile) ...[
              _InfoChip(icon: Icons.storefront_rounded, label: shopName),
              _InfoDivider(),
              _InfoChip(icon: Icons.person_outline_rounded, label: userName),
              _InfoDivider(),
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
              ),
            ] else
              const Icon(Icons.point_of_sale_rounded,
                  color: AppTheme.tealAccent, size: 18),
            const Spacer(),
            _HeaderAction(
              icon: Icons.add_circle_outline_rounded,
              label: isMobile ? '' : 'New  Ctrl+N',
              onTap: onNewSale,
            ),
            const SizedBox(width: 6),
            _HeaderAction(
              icon: Icons.pause_circle_outline_rounded,
              label: isMobile ? '' : 'Hold',
              onTap: () {},
            ),
            const SizedBox(width: 6),
            _HeaderAction(
              icon: Icons.play_circle_outline_rounded,
              label: isMobile ? '' : 'Resume',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.r6),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: label.isEmpty ? 8 : 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.r6),
            border:
                Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 5),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Control Strip ────────────────────────────────────────────────────────────

class _ControlStrip extends ConsumerStatefulWidget {
  const _ControlStrip({
    required this.isMobile,
    required this.customerController,
    required this.customerFocus,
    required this.customerResults,
    required this.onSearchCustomer,
    required this.onSelectCustomer,
    required this.onNewCustomer,
    required this.productController,
    required this.productFocus,
    required this.onProductSearchChanged,
    required this.onClearProduct,
    this.onClearCustomer,
  });

  final bool isMobile;
  final TextEditingController customerController;
  final FocusNode customerFocus;
  final List<Customer> customerResults;
  final ValueChanged<String> onSearchCustomer;
  final ValueChanged<Customer> onSelectCustomer;
  final Function([String? name]) onNewCustomer;
  final TextEditingController productController;
  final FocusNode productFocus;
  final ValueChanged<String> onProductSearchChanged;
  final VoidCallback onClearProduct;
  final VoidCallback? onClearCustomer;

  @override
  ConsumerState<_ControlStrip> createState() => _ControlStripState();
}

class _ControlStripState extends ConsumerState<_ControlStrip> {
  @override
  void initState() {
    super.initState();
    widget.customerFocus.addListener(_onFocusChange);
    widget.customerController.addListener(_onCustomerChange);
  }

  @override
  void dispose() {
    widget.customerFocus.removeListener(_onFocusChange);
    widget.customerController.removeListener(_onCustomerChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }
  
  void _onCustomerChange() {
    if (mounted) setState(() {});
  }

  static String _searchHint(String bizType) {
    switch (bizType) {
      case 'Pharmacy':
        return 'Search medicine / generic name / barcode  (F3)...';
      case 'Electronics':
        return 'Search product / model / serial no / SKU  (F3)...';
      case 'Grocery':
        return 'Search product / barcode / SKU  (F3)...';
      default:
        return 'Search product / barcode / SKU  (F3)...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.surface, // Moved inside decoration to fix crash
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: FutureBuilder<String?>(
        future: ref
            .read(settingsRepositoryProvider)
            .getSetting('inv_business_type'),
        builder: (context, snap) {
          final hint = _searchHint(snap.data ?? 'General');

          if (widget.isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomerCard(),
                const SizedBox(height: 8),
                _buildProductCard(hint),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Customer card — fixed compact width
              SizedBox(width: 270, child: _buildCustomerCard()),
              const SizedBox(width: 12),
              // Product search — expands to fill all remaining width
              Expanded(child: _buildProductCard(hint)),
            ],
          );
        },
      ),
    );
  }

  // ── Customer Card ───────────────────────────────────────────────────────────

  Widget _buildCustomerCard() {
    final name = widget.customerController.text;
    final isNamed = name.isNotEmpty && name != 'Walk-in Customer';

    return Focus(
      focusNode: widget.customerFocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          widget.onNewCustomer();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => widget.onNewCustomer(),
        child: _PosCard(
          highlighted: widget.customerFocus.hasFocus,
          child: Row(
            children: [
              // Avatar icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isNamed ? AppTheme.infoSurface : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppTheme.r8),
                ),
                child: Icon(
                  isNamed ? Icons.person_rounded : Icons.person_outline_rounded,
                  size: 17,
                  color: isNamed ? AppTheme.royalBlue : AppTheme.textMuted,
                ),
              ),
              const SizedBox(width: 10),
              // Label + customer name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'CUSTOMER  ·  F2',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMuted,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isNamed ? name : 'Walk-in Customer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: isNamed ? FontWeight.w700 : FontWeight.w400,
                          color: isNamed ? AppTheme.textPrimary : AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              // Action — clear or search icon
              if (isNamed)
                _IconMicro(
                    icon: Icons.close_rounded,
                    tooltip: 'Reset to Walk-in',
                    onTap: () {
                      widget.customerFocus.unfocus();
                      widget.onClearCustomer?.call();
                    })
              else
                const Icon(Icons.search_rounded, size: 15, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  // ── Product Search Card ─────────────────────────────────────────────────────

  Widget _buildProductCard(String hint) {
    final hasText = widget.productController.text.isNotEmpty;

    return _PosCard(
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 18,
            color: widget.productFocus.hasFocus
                ? AppTheme.royalBlue
                : AppTheme.textMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.productController,
              focusNode: widget.productFocus,
              onChanged: widget.onProductSearchChanged,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: false,
              ),
            ),
          ),
          if (hasText)
            _IconMicro(
                icon: Icons.close_rounded,
                tooltip: 'Clear  Esc',
                onTap: widget.onClearProduct),
          const SizedBox(width: 6),
          // Add customer button
          Tooltip(
            message: 'New Customer',
            child: Material(
              color: AppTheme.royalBlue,
              borderRadius: BorderRadius.circular(AppTheme.r8),
              child: InkWell(
                onTap: () => widget.onNewCustomer(),
                borderRadius: BorderRadius.circular(AppTheme.r8),
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.person_add_alt_1_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared card container ────────────────────────────────────────────────────

class _PosCard extends StatelessWidget {
  const _PosCard({required this.child, this.highlighted = false});
  final Widget child;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.r12),
        border: Border.all(
          color: highlighted ? AppTheme.royalBlue : AppTheme.border,
          width: highlighted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNavy.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── Micro icon button ────────────────────────────────────────────────────────

class _IconMicro extends StatelessWidget {
  const _IconMicro({required this.icon, this.onTap, this.tooltip});
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.r6),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 14, color: AppTheme.textMuted),
        ),
      ),
    );
  }
}

// ─── Customer suggestion list ─────────────────────────────────────────────────

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.results,
    required this.onSelect,
    required this.highlightedIndex,
  });
  final List<Customer> results;
  final ValueChanged<Customer> onSelect;
  final int highlightedIndex;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: results.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, thickness: 0.5, color: AppTheme.border),
        itemBuilder: (context, i) {
          final c = results[i];
          final isHl = i == highlightedIndex;
          return ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            tileColor: isHl ? AppTheme.selectedRow : null,
            leading: CircleAvatar(
              radius: 12,
              backgroundColor:
                  isHl ? AppTheme.royalBlue : AppTheme.infoSurface,
              child: Text(c.name[0].toUpperCase(),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isHl ? Colors.white : AppTheme.royalBlue)),
            ),
            title: Text(c.name,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isHl ? FontWeight.w800 : FontWeight.w600)),
            subtitle: c.phoneNumber != null
                ? Text(c.phoneNumber!,
                    style: const TextStyle(fontSize: 10))
                : null,
            onTap: () => onSelect(c),
          );
        },
      ),
    );
  }
}

// ─── No result / add new customer ────────────────────────────────────────────

class _NoResultBox extends StatelessWidget {
  const _NoResultBox({required this.typedName, required this.onAdd});
  final String typedName;
  final Function([String? name]) onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No customer found',
              style: TextStyle(
                  fontSize: 11, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          const Text('Press Enter to add as new customer',
              style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onAdd(typedName),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 14),
              label: Text('Add "$typedName"',
                  style: const TextStyle(fontSize: 11)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.tealAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

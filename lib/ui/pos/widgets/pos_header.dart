import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/database.dart';
import '../../../ui/shared/app_theme.dart';
import '../../../data/providers/current_shop_provider.dart';

/// POS top action bar + single compact control bar for customer and product search.
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
  final FocusNode productSearchFocus;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onNewSale;
  final VoidCallback? onClearCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessData = ref.watch(currentShopProvider);
    final userName = businessData?['ownerName'] ?? 'Ali Khan'; // Restore previous name as default
    final shopName = businessData?['shopName'] ?? 'Stockify';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SlimGradientHeader(
          isMobile: isMobile, 
          onNewSale: onNewSale, 
          userName: userName,
          shopName: shopName,
        ),
        _ControlBox(
          isMobile: isMobile,
          customerController: customerNameController,
          customerFocus: customerNameFocus,
          customerResults: customerSearchResults,
          onSearchCustomer: onSearchCustomers,
          onSelectCustomer: onSelectCustomer,
          onNewCustomer: onNewCustomer,
          productQuery: searchQuery,
          productFocus: productSearchFocus,
          onProductSearchChanged: onSearchChanged,
          onClearProduct: onClearSearch,
          onClearCustomer: onClearCustomer,
        ),
      ],
    );
  }
}

class _SlimGradientHeader extends StatelessWidget {
  const _SlimGradientHeader({
    required this.isMobile, 
    required this.onNewSale,
    required this.userName,
    required this.shopName,
  });
  
  final bool isMobile;
  final VoidCallback onNewSale;
  final String userName;
  final String shopName;

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
              _infoItem(Icons.business_rounded, shopName),
              _divider(),
              _infoItem(Icons.person_outline_rounded, userName),
              _divider(),
              _infoItem(Icons.calendar_today_rounded, DateFormat('dd MMM yyyy').format(DateTime.now())),
            ] else 
              const Icon(Icons.point_of_sale_rounded, color: AppTheme.tealAccent, size: 18),
            
            const Spacer(),
            
            _ActionChip(icon: Icons.add_circle_outline_rounded, label: isMobile ? '' : 'New (Ctrl+N)', onTap: onNewSale),
            const SizedBox(width: 4),
            _ActionChip(icon: Icons.pause_circle_outline_rounded, label: isMobile ? '' : 'Hold', onTap: () {}),
            const SizedBox(width: 4),
            _ActionChip(icon: Icons.play_circle_outline_rounded, label: isMobile ? '' : 'Resume', onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 12,
      width: 1,
      color: Colors.white.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label, required this.onTap});
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
          padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 8 : 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppTheme.r6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlBox extends StatefulWidget {
  const _ControlBox({
    required this.isMobile,
    required this.customerController,
    required this.customerFocus,
    required this.customerResults,
    required this.onSearchCustomer,
    required this.onSelectCustomer,
    required this.onNewCustomer,
    required this.productQuery,
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
  final String productQuery;
  final FocusNode productFocus;
  final ValueChanged<String> onProductSearchChanged;
  final VoidCallback onClearProduct;
  final VoidCallback? onClearCustomer;

  @override
  State<_ControlBox> createState() => _ControlBoxState();
}

class _ControlBoxState extends State<_ControlBox> {
  final LayerLink _layerLink = LayerLink();
  int _highlightedIndex = -1;

  @override
  void didUpdateWidget(covariant _ControlBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customerResults.isEmpty) {
      _highlightedIndex = -1;
    } else if (_highlightedIndex >= widget.customerResults.length) {
      _highlightedIndex = widget.customerResults.length - 1;
    }
  }

  void _handleKey(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    
    if (widget.customerResults.isNotEmpty && widget.customerFocus.hasFocus) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() => _highlightedIndex = (_highlightedIndex + 1) % widget.customerResults.length);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() => _highlightedIndex = (_highlightedIndex - 1 + widget.customerResults.length) % widget.customerResults.length);
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_highlightedIndex != -1) {
          widget.onSelectCustomer(widget.customerResults[_highlightedIndex]);
          setState(() => _highlightedIndex = -1);
        } else if (widget.customerController.text.trim().isNotEmpty) {
           widget.onNewCustomer(widget.customerController.text.trim());
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onSearchCustomer('');
      }
    } else if (widget.customerFocus.hasFocus && widget.customerResults.isEmpty && event.logicalKey == LogicalKeyboardKey.enter) {
        if (widget.customerController.text.trim().isNotEmpty && widget.customerController.text != 'Walk-in Customer') {
          widget.onNewCustomer(widget.customerController.text.trim());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.r8),
              border: Border.all(color: AppTheme.border, width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: widget.isMobile 
              ? Column(
                  children: [
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: _handleKey,
                        child: _MiniField(
                          icon: Icons.person_search_rounded,
                          controller: widget.customerController,
                          focusNode: widget.customerFocus,
                          hint: 'Select Customer (F2)...',
                          onChanged: (v) => v.length > 1 ? widget.onSearchCustomer(v) : null,
                          suffix: widget.customerController.text != 'Walk-in Customer' && widget.customerController.text.isNotEmpty
                            ? IconButton(
                                onPressed: widget.onClearCustomer,
                                icon: const Icon(Icons.close_rounded, size: 12),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                            : const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textMuted, size: 16),
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, color: AppTheme.border),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniField(
                            icon: Icons.search_rounded,
                            controller: TextEditingController(text: widget.productQuery)..selection = TextSelection.fromPosition(TextPosition(offset: widget.productQuery.length)),
                            focusNode: widget.productFocus,
                            hint: 'Search products (F3)...',
                            onChanged: widget.onProductSearchChanged,
                          ),
                        ),
                        _SmallAddBtn(onTap: () => widget.onNewCustomer()),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CompositedTransformTarget(
                        link: _layerLink,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: _handleKey,
                          child: _MiniField(
                            icon: Icons.person_search_rounded,
                            controller: widget.customerController,
                            focusNode: widget.customerFocus,
                            hint: 'Select Customer (F2)...',
                            onChanged: (v) => v.length > 1 ? widget.onSearchCustomer(v) : null,
                            suffix: widget.customerController.text != 'Walk-in Customer' && widget.customerController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: widget.onClearCustomer,
                                  icon: const Icon(Icons.close_rounded, size: 12),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                )
                              : const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textMuted, size: 16),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1.5, height: 24, color: AppTheme.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
                    Expanded(
                      flex: 5,
                      child: _MiniField(
                        icon: Icons.search_rounded,
                        controller: TextEditingController(text: widget.productQuery)..selection = TextSelection.fromPosition(TextPosition(offset: widget.productQuery.length)),
                        focusNode: widget.productFocus,
                        hint: 'Search products / SKU / barcode (F3)...',
                        onChanged: widget.onProductSearchChanged,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _SmallAddBtn(onTap: () => widget.onNewCustomer()),
                  ],
                ),
          ),
          
          if (widget.customerFocus.hasFocus && (widget.customerResults.isNotEmpty || (widget.customerController.text.length > 1 && widget.customerController.text != 'Walk-in Customer')))
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 42),
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(AppTheme.r12),
                color: Colors.white,
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.r12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: widget.customerResults.isNotEmpty 
                    ? _SuggestionList(
                        results: widget.customerResults, 
                        onSelect: widget.onSelectCustomer,
                        highlightedIndex: _highlightedIndex,
                      )
                    : _NoResultBox(typedName: widget.customerController.text, onAdd: widget.onNewCustomer),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniField extends StatelessWidget {
  const _MiniField({
    required this.icon,
    required this.controller,
    this.focusNode,
    required this.hint,
    this.onChanged,
    this.suffix,
  });

  final IconData icon;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.royalBlue.withValues(alpha: 0.6)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

class _SmallAddBtn extends StatelessWidget {
  const _SmallAddBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'New Customer (Ctrl+N)',
      child: Material(
        color: AppTheme.royalBlue,
        borderRadius: BorderRadius.circular(AppTheme.r6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.r6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.results, required this.onSelect, required this.highlightedIndex});
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
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5, color: AppTheme.border),
        itemBuilder: (context, i) {
          final c = results[i];
          final isHighlighted = i == highlightedIndex;
          return ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            tileColor: isHighlighted ? AppTheme.selectedRow : null,
            leading: CircleAvatar(
              radius: 11,
              backgroundColor: isHighlighted ? AppTheme.royalBlue : AppTheme.infoSurface,
              child: Text(c.name[0].toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isHighlighted ? Colors.white : AppTheme.royalBlue)),
            ),
            title: Text(c.name, style: TextStyle(fontSize: 11, fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600)),
            subtitle: c.phoneNumber != null ? Text(c.phoneNumber!, style: const TextStyle(fontSize: 9)) : null,
            onTap: () => onSelect(c),
          );
        },
      ),
    );
  }
}

class _NoResultBox extends StatelessWidget {
  const _NoResultBox({required this.typedName, required this.onAdd});
  final String typedName;
  final Function([String? name]) onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No customer found', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          const SizedBox(height: 6),
          const Text('Press Enter to add as new customer', style: TextStyle(fontSize: 10, color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onAdd(typedName),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 14),
              label: Text('Add "$typedName"', style: const TextStyle(fontSize: 11)),
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

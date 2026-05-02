import 'package:flutter/material.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/medicine_repository.dart';
import '../cart_provider.dart';
import '../../shared/app_theme.dart';

/// Clean professional product table for the POS screen.
/// White background, subtle borders, hover states, stock badges.
class ProductTable extends StatelessWidget {
  const ProductTable({
    super.key,
    required this.medicines,
    required this.repo,
    required this.cart,
    required this.selectedIndex,
    required this.scrollController,
    required this.onAddProduct,
  });

  final List<Medicine> medicines;
  final MedicineRepository repo;
  final CartState cart;
  final int selectedIndex;
  final ScrollController scrollController;
  final ValueChanged<int> onAddProduct;

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) return const _EmptyState();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        children: [
          const _TableHeader(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: medicines.length,
              itemBuilder: (context, index) => _ProductRow(
                medicine: medicines[index],
                repo: repo,
                cart: cart,
                isSelected: index == selectedIndex,
                onTap: () => onAddProduct(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Table Header ─────────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 1)),
      ),
      child: Row(
        children: const [
          _H('PRODUCT NAME', flex: 5),
          _H('CODE', flex: 2),
          _H('CATEGORY', flex: 2),
          _H('PRICE', flex: 2, right: true),
          _H('STOCK', flex: 2, right: true),
          SizedBox(width: 48), 
        ],
      ),
    );
  }
}

class _H extends StatelessWidget {
  const _H(this.label, {required this.flex, this.right = false});
  final String label;
  final int flex;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 0.5),
      ),
    );
  }
}

// ─── Product Row ──────────────────────────────────────────────────────────────

class _ProductRow extends StatefulWidget {
  const _ProductRow({
    required this.medicine,
    required this.repo,
    required this.cart,
    required this.isSelected,
    required this.onTap,
  });

  final Medicine medicine;
  final MedicineRepository repo;
  final CartState cart;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final inCartQty = widget.cart.items
        .where((i) => i.medicine.id == widget.medicine.id)
        .fold<int>(0, (s, i) => s + i.quantity);
    final inCart = inCartQty > 0;

    Color rowColor = widget.isSelected ? AppTheme.selectedRow : (inCart ? AppTheme.inCartRow : (_hovered ? AppTheme.tableRowHover : Colors.white));

    return FutureBuilder<List<Batch>>(
      future: widget.repo.getBatchesForMedicine(widget.medicine.id),
      builder: (context, snapshot) {
        final batches = snapshot.data ?? [];
        final totalStock = batches.fold<int>(0, (s, b) => s + b.quantity);
        final available = totalStock - inCartQty;

        final activeBatches = batches.where((b) => b.quantity > 0).toList()
          ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        final displayBatch = activeBatches.isNotEmpty ? activeBatches.first : (batches.isNotEmpty ? batches.first : null);

        final hasStock = available > 0;
        final isLow = hasStock && available < widget.medicine.minStock;
        final isOut = !hasStock && batches.isNotEmpty;
        final loading = !snapshot.hasData;

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: InkWell(
            onTap: batches.isEmpty && !loading ? null : widget.onTap,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: rowColor,
                border: const Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        _ProductIcon(isOut: isOut, isSelected: widget.isSelected),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.medicine.name, maxLines: 1, overflow: TextOverflow.ellipsis, 
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isOut ? AppTheme.textMuted : AppTheme.textPrimary, letterSpacing: -0.2)),
                              if (inCart) _InCartBadge(qty: inCartQty),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text(widget.medicine.code, style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: AppTheme.textMuted))),
                  Expanded(flex: 2, child: _CategoryPill(label: widget.medicine.mainCategory)),
                  Expanded(
                    flex: 2,
                    child: loading ? const _Skeleton(width: 40) : Text(
                      displayBatch != null ? 'PKR ${displayBatch.salePrice.toStringAsFixed(0)}' : '—',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: isOut ? AppTheme.textMuted : AppTheme.deepIndigo),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: loading ? const _Skeleton(width: 40) : Align(
                      alignment: Alignment.centerRight,
                      child: _StockBadge(available: available, isLow: isLow, isOut: isOut, noBatches: batches.isEmpty),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _AddButton(inCart: inCart, enabled: !loading, onTap: batches.isEmpty && !loading ? null : widget.onTap),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Row sub-widgets ──────────────────────────────────────────────────────────

class _ProductIcon extends StatelessWidget {
  const _ProductIcon({required this.isOut, required this.isSelected});
  final bool isOut;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isOut
            ? const Color(0xFFF3F4F6)
            : isSelected
                ? AppTheme.infoSurface
                : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppTheme.r8),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: 15,
        color: isOut ? AppTheme.textMuted : AppTheme.royalBlue,
      ),
    );
  }
}

class _InCartBadge extends StatelessWidget {
  const _InCartBadge({required this.qty});
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        gradient: AppTheme.successGradient,
        borderRadius: BorderRadius.circular(AppTheme.rPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 9, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            'In cart: $qty',
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(AppTheme.rPill),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF5B21B6),
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({
    required this.available,
    required this.isLow,
    required this.isOut,
    required this.noBatches,
  });
  final int available;
  final bool isLow;
  final bool isOut;
  final bool noBatches;

  @override
  Widget build(BuildContext context) {
    if (noBatches) {
      return _pill('No batch', AppTheme.textMuted,
          AppTheme.surfaceVariant, null, null);
    }
    if (isOut) {
      return _pill('Out of stock', AppTheme.redDanger,
          AppTheme.dangerSurface, null, AppTheme.dangerGradient);
    }
    if (isLow) {
      return _pill('$available low', AppTheme.amberWarning,
          AppTheme.warningSurface, AppTheme.warningGradient, null);
    }
    return _pill('$available', AppTheme.emeraldSuccess,
        AppTheme.successSurface, null, null);
  }

  Widget _pill(String text, Color fg, Color bg,
      LinearGradient? gradient, LinearGradient? gradientFull) {
    final useGradient = gradientFull != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: useGradient ? null : bg,
        gradient: useGradient ? gradientFull : gradient,
        borderRadius: BorderRadius.circular(AppTheme.rPill),
        border: useGradient
            ? null
            : Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: (gradient != null || useGradient) ? Colors.white : fg,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.inCart,
    required this.enabled,
    this.onTap,
  });
  final bool inCart;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 32,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.r8),
          child: Ink(
            decoration: BoxDecoration(
              gradient: inCart
                  ? AppTheme.successGradient
                  : AppTheme.primaryButtonGradient,
              borderRadius: BorderRadius.circular(AppTheme.r8),
            ),
            child: const Center(
              child: Icon(Icons.add_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(
          color: AppTheme.border,
          borderRadius: BorderRadius.circular(AppTheme.r4),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inventory_2_outlined,
                size: 48, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 18),
          const Text(
            'No products found',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different search term',
            style: TextStyle(
                fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

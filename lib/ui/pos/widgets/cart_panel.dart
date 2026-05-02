import 'package:flutter/material.dart';
import '../cart_provider.dart';
import '../../shared/app_theme.dart';
import 'payment_section.dart';

/// Right-side invoice panel — professional white design with customer summary.
class CartPanel extends StatelessWidget {
  const CartPanel({
    super.key,
    required this.cart,
    required this.notifier,
    required this.paymentMode,
    required this.changeReturn,
    required this.amountReceivedController,
    required this.amountReceivedFocus,
    required this.onClear,
    required this.onPaymentModeChanged,
    required this.onAmountChanged,
    required this.onCheckout,
    required this.onDiscountTap,
    this.selectedItemIndex = -1,
  });

  final CartState cart;
  final CartNotifier notifier;
  final String paymentMode;
  final double changeReturn;
  final TextEditingController amountReceivedController;
  final FocusNode amountReceivedFocus;
  final VoidCallback onClear;
  final ValueChanged<String> onPaymentModeChanged;
  final VoidCallback onAmountChanged;
  final VoidCallback onCheckout;
  final VoidCallback onDiscountTap;
  final int selectedItemIndex;

  @override
  Widget build(BuildContext context) {
    final totalQty = cart.items.fold<int>(0, (s, i) => s + i.quantity);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // ── Panel Header ────────────────────────────────────────────
          _PanelHeader(
            itemCount: totalQty,
            onClear: cart.items.isNotEmpty ? onClear : null,
          ),

          // ── Customer Mini Summary ───────────────────────────────────
          _CustomerSummary(customerName: cart.customer?.name ?? 'Walk-in Customer', customerPhone: cart.customer?.phoneNumber),

          // ── Item List ───────────────────────────────────────────────
          Expanded(
            child: cart.items.isEmpty
                ? const _EmptyCart()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartItemRow(
                        item: item,
                        isSelected: index == selectedItemIndex,
                        onIncrease: () => notifier.updateQuantity(item.batch.id, item.quantity + 1),
                        onDecrease: () => notifier.updateQuantity(item.batch.id, item.quantity - 1),
                        onRemove: () => notifier.removeItem(item.batch.id),
                      );
                    },
                  ),
          ),

          // ── Payment & Checkout ──────────────────────────────────────
          PaymentSection(
            cart: cart,
            paymentMode: paymentMode,
            changeReturn: changeReturn,
            amountReceivedController: amountReceivedController,
            amountReceivedFocus: amountReceivedFocus,
            onPaymentModeChanged: onPaymentModeChanged,
            onAmountChanged: onAmountChanged,
            onCheckout: onCheckout,
            onDiscountTap: onDiscountTap,
          ),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.itemCount, this.onClear});
  final int itemCount;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      decoration: const BoxDecoration(
        color: AppTheme.primaryNavy,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppTheme.tealAccent, size: 16),
          const SizedBox(width: 8),
          const Text(
            'BILLING PANEL (F4)',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
          if (itemCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.tealAccent, borderRadius: BorderRadius.circular(AppTheme.rPill)),
              child: Text('$itemCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
            ),
          ],
          const Spacer(),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white70),
              tooltip: 'Clear Cart',
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class _CustomerSummary extends StatelessWidget {
  const _CustomerSummary({required this.customerName, this.customerPhone});
  final String customerName;
  final String? customerPhone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SELECTED CUSTOMER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(customerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.royalBlue)),
              if (customerPhone != null) ...[
                const SizedBox(width: 8),
                Text(customerPhone!, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.isSelected = false,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final hasWarning = item.hasStockWarning;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.selectedRow : (hasWarning ? AppTheme.warningSurface : Colors.white),
        borderRadius: BorderRadius.circular(AppTheme.r8),
        border: Border.all(
          color: isSelected 
            ? AppTheme.royalBlue 
            : (hasWarning ? AppTheme.amberWarning.withValues(alpha: 0.3) : AppTheme.border),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.medicine.name,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'PKR ${item.batch.salePrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 9, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _QtyControls(qty: item.quantity, onIncrease: onIncrease, onDecrease: onDecrease),
              const SizedBox(width: 12),
              SizedBox(
                width: 60,
                child: Text(
                  'PKR ${item.total.toStringAsFixed(0)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.deepIndigo),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 14, color: AppTheme.textMuted),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (hasWarning) ...[
            const SizedBox(height: 4),
            Text('Only ${item.originalStock} in stock', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.amberWarning)),
          ],
        ],
      ),
    );
  }
}

class _QtyControls extends StatelessWidget {
  const _QtyControls({required this.qty, required this.onIncrease, required this.onDecrease});
  final int qty;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(Icons.remove_rounded, onDecrease),
          SizedBox(width: 24, child: Text('$qty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
          _StepBtn(Icons.add_rounded, onIncrease),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn(this.icon, this.onTap);
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.r4),
      child: SizedBox(width: 24, height: 24, child: Icon(icon, size: 12, color: AppTheme.textSecondary)),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 32, color: AppTheme.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          const Text('Cart is empty', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../cart_provider.dart';
import '../../shared/app_theme.dart';

/// Payment section: totals, payment modes, amount received,
/// change display, and the gradient checkout button.
class PaymentSection extends StatelessWidget {
  const PaymentSection({
    super.key,
    required this.cart,
    required this.paymentMode,
    required this.changeReturn,
    required this.amountReceivedController,
    required this.amountReceivedFocus,
    required this.onPaymentModeChanged,
    required this.onAmountChanged,
    required this.onCheckout,
    required this.onDiscountTap,
  });

  final CartState cart;
  final String paymentMode;
  final double changeReturn;
  final TextEditingController amountReceivedController;
  final FocusNode amountReceivedFocus;
  final ValueChanged<String> onPaymentModeChanged;
  final VoidCallback onAmountChanged;
  final VoidCallback onCheckout;
  final VoidCallback onDiscountTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Totals ──────────────────────────────────────────────
          _TotalsBlock(cart: cart, onDiscountTap: onDiscountTap),

          const SizedBox(height: 12),

          // ── Payment Mode ────────────────────────────────────────
          Row(
            children: [
              _ModeChip(label: 'Cash', selected: paymentMode == 'Cash', onTap: () => onPaymentModeChanged('Cash')),
              const SizedBox(width: 6),
              _ModeChip(label: 'Card', selected: paymentMode == 'Card', onTap: () => onPaymentModeChanged('Card')),
              const SizedBox(width: 6),
              _ModeChip(label: 'Online', selected: paymentMode == 'Online', onTap: () => onPaymentModeChanged('Online')),
            ],
          ),

          const SizedBox(height: 12),

          // ── Amount Received + Change ────────────────────────────
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: amountReceivedController,
                  focusNode: amountReceivedFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => onAmountChanged(),
                  onSubmitted: (_) => onCheckout(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    labelText: 'Received',
                    labelStyle: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    prefixText: 'PKR ',
                    prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    filled: true,
                    fillColor: AppTheme.surfaceVariant,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.r8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _ChangeBox(change: changeReturn),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Checkout Button ──────────────────────────
          _CheckoutBtn(
            enabled: cart.items.isNotEmpty,
            onTap: onCheckout,
          ),
        ],
      ),
    );
  }
}

class _TotalsBlock extends StatelessWidget {
  const _TotalsBlock({required this.cart, required this.onDiscountTap});
  final CartState cart;
  final VoidCallback onDiscountTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Row(label: 'Subtotal', value: cart.subTotal),
        _DiscountRow(value: cart.discountAmount, displayValue: cart.discountValue, type: cart.discountType, onTap: onDiscountTap),
        if (cart.taxAmount > 0) _Row(label: 'Tax', value: cart.taxAmount),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.deepIndigo,
            borderRadius: BorderRadius.circular(AppTheme.r8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('GRAND TOTAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing: 0.5)),
              Text(
                'PKR ${cart.grandTotal.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          Text('PKR ${value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DiscountRow extends StatelessWidget {
  const _DiscountRow({required this.value, required this.displayValue, required this.type, required this.onTap});
  final double value;
  final double displayValue;
  final String type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            const Text('Discount', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(width: 6),
            const Icon(Icons.edit_note_rounded, size: 14, color: AppTheme.royalBlue),
            const Spacer(),
            Text('– PKR ${value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.redDanger)),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.r6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppTheme.royalBlue : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.r6),
            border: Border.all(color: selected ? AppTheme.royalBlue : AppTheme.border),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _ChangeBox extends StatelessWidget {
  const _ChangeBox({required this.change});
  final double change;

  @override
  Widget build(BuildContext context) {
    final isNeg = change < 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isNeg ? AppTheme.dangerSurface : AppTheme.successSurface,
        borderRadius: BorderRadius.circular(AppTheme.r8),
      ),
      child: Column(
        children: [
          Text(isNeg ? 'DUE' : 'CHANGE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: isNeg ? AppTheme.redDanger : AppTheme.emeraldSuccess)),
          Text('PKR ${change.abs().toStringAsFixed(0)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: isNeg ? AppTheme.redDanger : AppTheme.emeraldSuccess)),
        ],
      ),
    );
  }
}

class _CheckoutBtn extends StatelessWidget {
  const _CheckoutBtn({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.royalBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r8)),
          elevation: 0,
        ),
        child: const Text('CHECKOUT (F2)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
      ),
    );
  }
}

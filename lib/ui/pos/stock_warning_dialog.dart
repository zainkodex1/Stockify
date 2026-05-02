import 'package:flutter/material.dart';
import '../shared/app_theme.dart';

class StockWarningResult {
  final bool proceed;
  final bool dontShowAgain;
  const StockWarningResult({required this.proceed, required this.dontShowAgain});
}

class StockWarningDialog extends StatefulWidget {
  final String productName;
  final int availableStock;
  final int requestedQuantity;
  final int alreadyInCart;

  const StockWarningDialog({
    super.key,
    required this.productName,
    required this.availableStock,
    required this.requestedQuantity,
    required this.alreadyInCart,
  });

  static Future<StockWarningResult?> show(
    BuildContext context, {
    required String productName,
    required int availableStock,
    required int requestedQuantity,
    required int alreadyInCart,
  }) async {
    return await showDialog<StockWarningResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StockWarningDialog(
        productName: productName,
        availableStock: availableStock,
        requestedQuantity: requestedQuantity,
        alreadyInCart: alreadyInCart,
      ),
    );
  }

  @override
  State<StockWarningDialog> createState() => _StockWarningDialogState();
}

class _StockWarningDialogState extends State<StockWarningDialog> {
  bool _dontShowAgain = false;

  int get totalRequested => widget.alreadyInCart + widget.requestedQuantity;
  int get shortage => totalRequested - widget.availableStock;
  bool get isOutOfStock => widget.availableStock <= 0;
  bool get willExceedStock => totalRequested > widget.availableStock;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 400,
        color: AppTheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isOutOfStock 
                  ? const LinearGradient(colors: [AppTheme.redDanger, Color(0xFF991B1B)])
                  : const LinearGradient(colors: [AppTheme.amberWarning, Color(0xFF92400E)]),
              ),
              child: Row(
                children: [
                  Icon(isOutOfStock ? Icons.report_gmailerrorred_rounded : Icons.warning_amber_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(isOutOfStock ? 'OUT OF STOCK' : 'LOW STOCK ALERT', 
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r12)),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_rounded, color: AppTheme.textMuted, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(widget.productName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildStatRow('Current Stock', '${widget.availableStock} Units', isOutOfStock ? AppTheme.redDanger : AppTheme.amberWarning),
                  _buildStatRow('In Cart', '${widget.alreadyInCart} Units', AppTheme.royalBlue),
                  _buildStatRow('Adding Now', '${widget.requestedQuantity} Units', AppTheme.tealAccent),
                  
                  if (willExceedStock) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppTheme.dangerSurface, borderRadius: BorderRadius.circular(AppTheme.r12), border: Border.all(color: AppTheme.redDanger.withValues(alpha: 0.2))),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: AppTheme.redDanger, size: 18),
                          const SizedBox(width: 10),
                          Text('Shortage of $shortage unit(s)', style: const TextStyle(color: AppTheme.redDanger, fontWeight: FontWeight.w700, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => setState(() => _dontShowAgain = !_dontShowAgain),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _dontShowAgain, 
                          onChanged: (v) => setState(() => _dontShowAgain = v ?? false),
                          activeColor: isOutOfStock ? AppTheme.redDanger : AppTheme.amberWarning,
                        ),
                        const Expanded(child: Text('Don\'t warn me again for this item', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, const StockWarningResult(proceed: false, dontShowAgain: false)),
                          child: const Text('CANCEL'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, StockWarningResult(proceed: true, dontShowAgain: _dontShowAgain)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isOutOfStock ? AppTheme.redDanger : AppTheme.amberWarning,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('ADD ANYWAY', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppTheme.rPill)),
            child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

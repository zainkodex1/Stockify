import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/repositories/sale_repository.dart';
import '../../data/repositories/medicine_repository.dart';
import '../../data/providers/current_shop_provider.dart';
import '../../data/database/database.dart';
import 'dart:convert';
import 'package:printing/printing.dart';
import '../sales/sale_pdf_generator.dart';
import '../sales/receipt_preview_screen.dart';
import '../shared/app_theme.dart';
import 'cart_provider.dart';
import '../../core/config/custom_field_service.dart';

class CheckoutDialog extends ConsumerStatefulWidget {
  final double? initialAmount;
  final String? initialPaymentMode;

  const CheckoutDialog({super.key, this.initialAmount, this.initialPaymentMode});

  @override
  ConsumerState<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends ConsumerState<CheckoutDialog> {
  bool _isProcessing = false;
  late String _paymentMode;
  final TextEditingController _amountReceivedController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  double _change = 0.0;

  @override
  void initState() {
    super.initState();
    final cart = ref.read(cartProvider);
    _paymentMode = widget.initialPaymentMode ?? 'Cash';
    
    if (widget.initialAmount != null && widget.initialAmount! > 0) {
      _amountReceivedController.text = widget.initialAmount!.toStringAsFixed(2);
    } else {
      _amountReceivedController.text = cart.grandTotal.toStringAsFixed(2);
    }
    
    _calculateChange();
    _amountReceivedController.addListener(_calculateChange);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _amountFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountReceivedController.removeListener(_calculateChange);
    _amountReceivedController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  void _calculateChange() {
    final cart = ref.read(cartProvider);
    final amountReceived = double.tryParse(_amountReceivedController.text) ?? 0.0;
    setState(() {
      _change = amountReceived - cart.grandTotal;
    });
  }

  Future<void> _handleConfirm() async {
    if (_isProcessing) return;
    final cart = ref.read(cartProvider);
    
    if (_paymentMode == 'Cash') {
      final amountReceived = double.tryParse(_amountReceivedController.text) ?? 0.0;
      if (amountReceived < (cart.grandTotal - 0.01)) { // tolerance for rounding
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amount received is less than total'), backgroundColor: AppTheme.redDanger),
        );
        return;
      }
    }
    
    setState(() => _isProcessing = true);
    
    try {
      final saleRepo = ref.read(saleRepositoryProvider);
      final shopData = ref.read(currentShopProvider);
      final customService = ref.read(customFieldServiceProvider);

      // Snapshot Custom Fields for Invoice
      final bizType = shopData?['businessType'] as String? ?? 'General';
      final activeDefs = await customService.getActiveProductFields(bizType);
      
      Map<int, String> itemSnapshots = {};
      for (final item in cart.items) {
        final values = await customService.getValues('product', item.medicine.id);
        List<Map<String, dynamic>> snapshotData = [];
        for (final val in values) {
          try {
            final def = activeDefs.firstWhere((d) => d.id == val.definitionId);
            if (def.showInInvoice) {
              // Resolve the display value
              String displayVal;
              if (val.valueBool == true) {
                displayVal = 'Yes';
              } else if (val.valueBool == false) {
                displayVal = ''; // Don't print unchecked booleans
              } else {
                displayVal = val.valueText?.trim() ?? val.valueNumber?.toString() ?? '';
              }
              // Only add if the value is meaningful
              if (displayVal.isNotEmpty && displayVal != 'null') {
                snapshotData.add({'label': def.fieldLabel, 'value': displayVal});
              }
            }
          } catch (_) {}
        }
        if (snapshotData.isNotEmpty) {
          itemSnapshots[item.batch.id] = jsonEncode(snapshotData);
        }
      }
      
      final saleId = await saleRepo.createSale(
        SalesCompanion(
          invoiceNumber: drift.Value('INV-${DateTime.now().millisecondsSinceEpoch}'),
          date: drift.Value(DateTime.now()),
          customerId: cart.customer != null ? drift.Value(cart.customer!.id) : const drift.Value.absent(),
          subTotal: drift.Value(cart.subTotal),
          discount: drift.Value(cart.discountAmount),
          tax: drift.Value(cart.taxAmount),
          posFee: drift.Value(cart.posFee),
          grandTotal: drift.Value(cart.grandTotal),
          paymentMethod: drift.Value(_paymentMode),
        ),
        cart.items.map((item) => SaleItemsCompanion(
          batchId: drift.Value(item.batch.id),
          quantity: drift.Value(item.quantity),
          price: drift.Value(item.selectedUnit.salePrice),
          total: drift.Value(item.total),
          unitName: drift.Value(item.selectedUnit.name),
          conversionFactor: drift.Value(item.selectedUnit.conversionFactor),
          customFieldsJson: drift.Value(itemSnapshots[item.batch.id]),
        )).toList(),
      );
      
      final amountReceivedValue = _paymentMode == 'Cash' 
          ? (double.tryParse(_amountReceivedController.text) ?? cart.grandTotal)
          : cart.grandTotal;
      final changeGiven = amountReceivedValue - cart.grandTotal;
      
      final pdfBytes = await SalePdfGenerator.generateSalePdf(
        sale: Sale(
          id: saleId,
          invoiceNumber: 'INV-$saleId',
          date: DateTime.now(),
          customerId: cart.customer?.id,
          subTotal: cart.subTotal,
          discount: cart.discountAmount,
          tax: cart.taxAmount,
          posFee: cart.posFee,
          grandTotal: cart.grandTotal,
          paymentMethod: _paymentMode,
          userId: null,
        ),
        items: cart.items.map((i) => SaleItem(
          id: 0,
          saleId: saleId,
          batchId: i.batch.id,
          quantity: i.quantity,
          price: i.selectedUnit.salePrice,
          total: i.total,
          unitName: i.selectedUnit.name,
          conversionFactor: i.selectedUnit.conversionFactor,
          customFieldsJson: itemSnapshots[i.batch.id],
        )).toList(),
        medicines: cart.items.map((i) => i.medicine).toList(),
        customer: cart.customer,
        shopData: shopData,
        amountReceived: amountReceivedValue,
        changeGiven: changeGiven > 0 ? changeGiven : null,
        discountType: cart.discountType,
        discountValue: cart.discountValue,
      );

      ref.read(cartProvider.notifier).clear();
      
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context, 
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => ReceiptPreviewScreen(
              title: 'Receipt Preview',
              buildPdf: (_) => Future.value(pdfBytes),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.redDanger));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const _ConfirmIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter): const _ConfirmIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _CancelIntent(),
      },
      child: Actions(
        actions: {
          _ConfirmIntent: CallbackAction<_ConfirmIntent>(onInvoke: (_) => _handleConfirm()),
          _CancelIntent: CallbackAction<_CancelIntent>(onInvoke: (_) => Navigator.pop(context)),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 500,
              color: AppTheme.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gradient Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Complete Transaction', 
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                            Text('Finalize sale and generate invoice', 
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer if selected
                        if (cart.customer != null) ...[
                          _buildCustomerBar(cart.customer!),
                          const SizedBox(height: 16),
                        ],
                        
                        // Grand Total Display
                        _buildTotalDisplay(cart.grandTotal),
                        const SizedBox(height: 24),
                        
                        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildModeBtn('Cash', Icons.payments_rounded),
                            const SizedBox(width: 10),
                            _buildModeBtn('Card', Icons.credit_card_rounded),
                            const SizedBox(width: 10),
                            _buildModeBtn('Online', Icons.qr_code_scanner_rounded),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        if (_paymentMode == 'Cash') ...[
                          const Text('Cash Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _amountReceivedController,
                                  focusNode: _amountFocus,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                                  decoration: const InputDecoration(
                                    labelText: 'Amount Received',
                                    prefixText: 'PKR ',
                                  ),
                                  onSubmitted: (_) => _handleConfirm(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: _buildChangeBox(),
                              ),
                            ],
                          ),
                        ] else
                          _buildNonCashInfo(),

                        const SizedBox(height: 32),
                        
                        // Final Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 56)),
                                child: const Text('CANCEL (Esc)'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _isProcessing ? null : _handleConfirm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.emeraldSuccess,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 56),
                                ),
                                child: _isProcessing
                                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.print_rounded, size: 20),
                                          SizedBox(width: 10),
                                          Text('PAY & PRINT (Enter)', 
                                            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                                        ],
                                      ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerBar(Customer c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.infoSurface,
        borderRadius: BorderRadius.circular(AppTheme.r12),
        border: Border.all(color: AppTheme.royalBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_rounded, color: AppTheme.royalBlue, size: 18),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              if (c.phoneNumber != null)
                Text(c.phoneNumber!, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDisplay(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.totalSurface,
        borderRadius: BorderRadius.circular(AppTheme.r16),
        border: Border.all(color: AppTheme.royalBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.deepIndigo)),
          Text('PKR ${total.toStringAsFixed(2)}', 
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.deepIndigo)),
        ],
      ),
    );
  }

  Widget _buildModeBtn(String mode, IconData icon) {
    final active = _paymentMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          _paymentMode = mode;
          if (mode != 'Cash') {
            _amountReceivedController.text = ref.read(cartProvider).grandTotal.toStringAsFixed(2);
          }
        }),
        borderRadius: BorderRadius.circular(AppTheme.r12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppTheme.royalBlue : AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.r12),
            border: Border.all(color: active ? AppTheme.royalBlue : AppTheme.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: active ? Colors.white : AppTheme.textSecondary, size: 20),
              const SizedBox(height: 4),
              Text(mode, style: TextStyle(color: active ? Colors.white : AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeBox() {
    final isNeg = _change < -0.01;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isNeg ? AppTheme.dangerSurface : AppTheme.successSurface,
        borderRadius: BorderRadius.circular(AppTheme.r12),
        border: Border.all(color: isNeg ? AppTheme.redDanger : AppTheme.emeraldSuccess, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isNeg ? 'UNDERPAID' : 'CHANGE', 
            style: TextStyle(color: isNeg ? AppTheme.redDanger : AppTheme.emeraldSuccess, fontSize: 9, fontWeight: FontWeight.w800)),
          Text('PKR ${_change.abs().toStringAsFixed(0)}', 
            style: TextStyle(color: isNeg ? AppTheme.redDanger : AppTheme.emeraldSuccess, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildNonCashInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.infoSurface, borderRadius: BorderRadius.circular(AppTheme.r12)),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppTheme.royalBlue, size: 18),
          const SizedBox(width: 12),
          Text('Exact amount will be charged via $_paymentMode', 
            style: const TextStyle(fontSize: 12, color: AppTheme.royalBlue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ConfirmIntent extends Intent { const _ConfirmIntent(); }
class _CancelIntent extends Intent { const _CancelIntent(); }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/medicine_repository.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/database/database.dart';
import '../../utils/sample_data_importer.dart';
import 'cart_provider.dart';
import 'checkout_dialog.dart';
import 'customer_entry_dialog.dart';
import 'stock_warning_dialog.dart';
import 'widgets/pos_header.dart';
import 'widgets/product_table.dart';
import 'widgets/cart_panel.dart';
import '../../data/repositories/settings_repository.dart';
import 'unit_selection_dialog.dart';
import '../shared/app_theme.dart';

// ── Intents for Keyboard Shortcuts ───────────────────────────────────────────
class _FocusCustomerIntent extends Intent { const _FocusCustomerIntent(); }
class _FocusProductSearchIntent extends Intent { const _FocusProductSearchIntent(); }
class _FocusCartIntent extends Intent { const _FocusCartIntent(); }
class _FocusAmountReceivedIntent extends Intent { const _FocusAmountReceivedIntent(); }
class _CheckoutIntent extends Intent { const _CheckoutIntent(); }
class _ClearSearchIntent extends Intent { const _ClearSearchIntent(); }
class _IncreaseQtyIntent extends Intent { const _IncreaseQtyIntent(); }
class _DecreaseQtyIntent extends Intent { const _DecreaseQtyIntent(); }
class _RemoveItemIntent extends Intent { const _RemoveItemIntent(); }
class _NewSaleIntent extends Intent { const _NewSaleIntent(); }
class _NavUpIntent extends Intent { const _NavUpIntent(); }
class _NavDownIntent extends Intent { const _NavDownIntent(); }
class _SelectIntent extends Intent { const _SelectIntent(); }
class _PaymentCashIntent extends Intent { const _PaymentCashIntent(); }
class _PaymentCardIntent extends Intent { const _PaymentCardIntent(); }
class _PaymentOnlineIntent extends Intent { const _PaymentOnlineIntent(); }

// ─────────────────────────────────────────────────────────────────────────────

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  String _searchQuery = '';
  final FocusNode _productSearchFocus = FocusNode();
  final FocusNode _customerNameFocus = FocusNode();
  final FocusNode _amountReceivedFocus = FocusNode();
  final FocusNode _cartFocus = FocusNode();
  final ScrollController _productGridController = ScrollController();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _productSearchController = TextEditingController();
  final TextEditingController _amountReceivedController = TextEditingController();

  List<Customer> _customerSearchResults = [];
  int _selectedProductIndex = 0;
  int _selectedCartItemIndex = -1; // -1 means none selected
  String _paymentMode = 'Cash';
  double _changeReturn = 0.0;
  final Set<int> _dismissedStockWarnings = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerRepo = ref.read(customerRepositoryProvider);
      final walkInCustomer = await customerRepo.createOrGetCustomer('Walk-in Customer', null);
      if (mounted) {
        ref.read(cartProvider.notifier).setCustomer(walkInCustomer);
        _customerNameController.text = walkInCustomer.name;
        _customerPhoneController.text = walkInCustomer.phoneNumber ?? '';
        _productSearchFocus.requestFocus();
        _checkAndLoadSampleData();
      }
    });
  }

  Future<void> _checkAndLoadSampleData() async {
    final medicineRepo = ref.read(medicineRepositoryProvider);
    final medicines = await medicineRepo.getAllMedicines();
    if (medicines.isEmpty) {
      if (!mounted) return;
      try {
        final database = ref.read(databaseProvider);
        final importer = SampleDataImporter(database);
        await importer.importAllData();
        if (mounted) setState(() {});
      } catch (e) { print('Error auto-loading data: $e'); }
    }
  }

  @override
  void dispose() {
    _productSearchFocus.dispose();
    _customerNameFocus.dispose();
    _amountReceivedFocus.dispose();
    _cartFocus.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _productSearchController.dispose();
    _amountReceivedController.dispose();
    _productGridController.dispose();
    super.dispose();
  }

  void _moveProductSelection(int delta, int totalItems) {
    if (totalItems == 0) return;
    setState(() {
      _selectedProductIndex = (_selectedProductIndex + delta).clamp(0, totalItems - 1);
      _selectedCartItemIndex = -1;
    });
    _scrollToSelected();
  }

  void _moveCartSelection(int delta, int totalItems) {
    if (totalItems == 0) return;
    setState(() {
      if (_selectedCartItemIndex == -1) {
        _selectedCartItemIndex = delta > 0 ? 0 : totalItems - 1;
      } else {
        _selectedCartItemIndex = (_selectedCartItemIndex + delta).clamp(0, totalItems - 1);
      }
      _selectedProductIndex = -1;
    });
  }

  void _scrollToSelected() {
    if (!_productGridController.hasClients) return;
    const itemHeight = 48.0; // Compact row height
    final offset = _selectedProductIndex * itemHeight;
    final viewportHeight = _productGridController.position.viewportDimension;
    if (offset < _productGridController.offset || offset > _productGridController.offset + viewportHeight - itemHeight) {
      _productGridController.animateTo(offset.clamp(0, _productGridController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  Future<void> _addProductToIndex(int index, List<Medicine> filteredList) async {
    if (index < 0 || index >= filteredList.length) return;
    final medicine = filteredList[index];
    final medicineRepo = ref.read(medicineRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    
    final batches = await medicineRepo.getBatchesForMedicine(medicine.id);
    if (batches.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No stock available'), backgroundColor: Colors.red));
      return;
    }

    // Determine the unit
    final units = await medicineRepo.getProductUnits(medicine.id);
    final showUnitSelector = await settingsRepo.getSetting('pos_show_unit_selector') == 'true';
    
    ProductUnit? selectedUnit;
    if (showUnitSelector && units.length > 1) {
      if (!mounted) return;
      selectedUnit = await UnitSelectionDialog.show(context, medicine, units);
      if (selectedUnit == null) return; // User cancelled
    } else {
      selectedUnit = units.firstWhere((u) => u.isDefaultSaleUnit, orElse: () => units.first);
    }

    final totalStock = batches.fold<int>(0, (sum, b) => sum + b.quantity);
    final alreadyInCartBaseQty = cartNotifier.getMedicineQuantityInCart(medicine.id);
    final bestBatch = (List<Batch>.from(batches)..sort((a, b) => a.expiryDate.compareTo(b.expiryDate))).first;
    
    final requestedBaseQty = selectedUnit.conversionFactor;
    final availableStock = totalStock - alreadyInCartBaseQty;

    if (availableStock < requestedBaseQty && !_dismissedStockWarnings.contains(medicine.id)) {
       final result = await StockWarningDialog.show(context, productName: medicine.name, availableStock: totalStock, requestedQuantity: requestedBaseQty.toInt(), alreadyInCart: alreadyInCartBaseQty);
       if (result == null || !result.proceed) return;
       if (result.dontShowAgain) setState(() => _dismissedStockWarnings.add(medicine.id));
    }

    cartNotifier.addItem(medicine, bestBatch, selectedUnit, totalBatchStock: totalStock);
    setState(() => _selectedCartItemIndex = ref.read(cartProvider).items.length - 1);
  }

  Future<void> _searchCustomers(String query) async {
    if (query.isEmpty || query.length < 2) { setState(() => _customerSearchResults = []); return; }
    final results = await ref.read(customerRepositoryProvider).searchCustomers(query);
    setState(() { _customerSearchResults = results.where((c) => c.name.toLowerCase() != 'walk-in customer').toList(); });
  }

  Future<void> _clearCustomer() async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final walkIn = await customerRepo.createOrGetCustomer('Walk-in Customer', null);
    _selectCustomer(walkIn);
  }

  void _selectCustomer(Customer customer) {
    _customerNameController.text = customer.name;
    _customerPhoneController.text = customer.phoneNumber ?? '';
    ref.read(cartProvider.notifier).setCustomer(customer);
    setState(() => _customerSearchResults = []);
    _productSearchFocus.requestFocus();
  }

  void _calculateChange() {
    final cart = ref.read(cartProvider);
    final received = double.tryParse(_amountReceivedController.text) ?? 0.0;
    setState(() => _changeReturn = received - cart.grandTotal);
  }

  void _handleCheckout() {
    final cart = ref.read(cartProvider);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }
    showDialog(context: context, builder: (context) => CheckoutDialog(initialAmount: double.tryParse(_amountReceivedController.text), initialPaymentMode: _paymentMode)).then((_) {
      _amountReceivedController.clear();
      _newSale();
    });
  }

  void _newSale() {
    ref.read(cartProvider.notifier).clear();
    setState(() { _changeReturn = 0.0; _paymentMode = 'Cash'; _searchQuery = ''; _selectedProductIndex = 0; _selectedCartItemIndex = -1; });
    _clearCustomer();
    _productSearchController.clear();
    _productSearchFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final medicineRepo = ref.watch(medicineRepositoryProvider);
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return StreamBuilder<List<Medicine>>(
      stream: medicineRepo.watchAllMedicines(),
      builder: (context, snapshot) {
        final allMedicines = snapshot.data ?? [];
        final query = _productSearchController.text.toLowerCase();
        final filteredMedicines = query.isEmpty 
            ? allMedicines 
            : allMedicines.where((m) => 
                m.name.toLowerCase().contains(query) || 
                m.code.toLowerCase().contains(query)).toList();

        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.f2): const _FocusCustomerIntent(),
            LogicalKeySet(LogicalKeyboardKey.f3): const _FocusProductSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF): const _FocusProductSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.f4): const _FocusCartIntent(),
            LogicalKeySet(LogicalKeyboardKey.f6): const _PaymentCashIntent(),
            LogicalKeySet(LogicalKeyboardKey.f7): const _PaymentCardIntent(),
            LogicalKeySet(LogicalKeyboardKey.f8): const _PaymentOnlineIntent(),
            LogicalKeySet(LogicalKeyboardKey.f9): const _FocusAmountReceivedIntent(),
            LogicalKeySet(LogicalKeyboardKey.f10): const _CheckoutIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter): const _CheckoutIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): const _NewSaleIntent(),
            LogicalKeySet(LogicalKeyboardKey.escape): const _ClearSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowUp): const _NavUpIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowDown): const _NavDownIntent(),
            LogicalKeySet(LogicalKeyboardKey.enter): const _SelectIntent(),
            LogicalKeySet(LogicalKeyboardKey.add): const _IncreaseQtyIntent(),
            LogicalKeySet(LogicalKeyboardKey.equal): const _IncreaseQtyIntent(),
            LogicalKeySet(LogicalKeyboardKey.minus): const _DecreaseQtyIntent(),
            LogicalKeySet(LogicalKeyboardKey.delete): const _RemoveItemIntent(),
          },
          child: Actions(
            actions: {
              _FocusCustomerIntent: CallbackAction<_FocusCustomerIntent>(onInvoke: (_) { _customerNameFocus.requestFocus(); return null; }),
              _FocusProductSearchIntent: CallbackAction<_FocusProductSearchIntent>(onInvoke: (_) { _productSearchFocus.requestFocus(); return null; }),
              _FocusCartIntent: CallbackAction<_FocusCartIntent>(onInvoke: (_) { _cartFocus.requestFocus(); setState(() => _selectedCartItemIndex = cart.items.isEmpty ? -1 : 0); return null; }),
              _FocusAmountReceivedIntent: CallbackAction<_FocusAmountReceivedIntent>(onInvoke: (_) { _amountReceivedFocus.requestFocus(); return null; }),
              _PaymentCashIntent: CallbackAction<_PaymentCashIntent>(onInvoke: (_) { setState(() => _paymentMode = 'Cash'); return null; }),
              _PaymentCardIntent: CallbackAction<_PaymentCardIntent>(onInvoke: (_) { setState(() => _paymentMode = 'Card'); return null; }),
              _PaymentOnlineIntent: CallbackAction<_PaymentOnlineIntent>(onInvoke: (_) { setState(() => _paymentMode = 'Online'); return null; }),
              _CheckoutIntent: CallbackAction<_CheckoutIntent>(onInvoke: (_) { _handleCheckout(); return null; }),
              _NewSaleIntent: CallbackAction<_NewSaleIntent>(onInvoke: (_) { _newSale(); return null; }),
              _ClearSearchIntent: CallbackAction<_ClearSearchIntent>(onInvoke: (_) { 
                if (_customerSearchResults.isNotEmpty) setState(() => _customerSearchResults = []);
                else if (_productSearchController.text.isNotEmpty) setState(() { _productSearchController.clear(); _selectedProductIndex = 0; });
                return null;
              }),
              _NavUpIntent: CallbackAction<_NavUpIntent>(onInvoke: (_) {
                if (_cartFocus.hasFocus) _moveCartSelection(-1, cart.items.length);
                else _moveProductSelection(-1, filteredMedicines.length);
                return null;
              }),
              _NavDownIntent: CallbackAction<_NavDownIntent>(onInvoke: (_) {
                if (_cartFocus.hasFocus) _moveCartSelection(1, cart.items.length);
                else _moveProductSelection(1, filteredMedicines.length);
                return null;
              }),
              _SelectIntent: CallbackAction<_SelectIntent>(onInvoke: (_) {
                if (_amountReceivedFocus.hasFocus) _handleCheckout();
                else if (_productSearchFocus.hasFocus || (!_cartFocus.hasFocus && !_customerNameFocus.hasFocus)) _addProductToIndex(_selectedProductIndex, filteredMedicines);
                return null;
              }),
              _IncreaseQtyIntent: CallbackAction<_IncreaseQtyIntent>(onInvoke: (_) {
                if (cart.items.isNotEmpty) {
                  final idx = _selectedCartItemIndex != -1 ? _selectedCartItemIndex : cart.items.length - 1;
                  cartNotifier.updateQuantity(cart.items[idx].batch.id, cart.items[idx].quantity + 1);
                }
                return null;
              }),
              _DecreaseQtyIntent: CallbackAction<_DecreaseQtyIntent>(onInvoke: (_) {
                if (cart.items.isNotEmpty) {
                  final idx = _selectedCartItemIndex != -1 ? _selectedCartItemIndex : cart.items.length - 1;
                  cartNotifier.updateQuantity(cart.items[idx].batch.id, cart.items[idx].quantity - 1);
                }
                return null;
              }),
              _RemoveItemIntent: CallbackAction<_RemoveItemIntent>(onInvoke: (_) {
                if (cart.items.isNotEmpty) {
                  final idx = _selectedCartItemIndex != -1 ? _selectedCartItemIndex : cart.items.length - 1;
                  cartNotifier.removeItem(cart.items[idx].batch.id);
                  setState(() => _selectedCartItemIndex = cart.items.isEmpty ? -1 : (_selectedCartItemIndex.clamp(0, cart.items.length - 1).toInt()));
                }
                return null;
              }),
            },
            child: Scaffold(
              backgroundColor: AppTheme.appBackground,
              body: _buildLayout(context, filteredMedicines, medicineRepo, cart, cartNotifier),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, List<Medicine> filteredMedicines, MedicineRepository repo, CartState cart, CartNotifier cartNotifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        final header = PosHeader(
          isMobile: isMobile,
          customerNameController: _customerNameController,
          customerPhoneController: _customerPhoneController,
          customerNameFocus: _customerNameFocus,
          customerSearchResults: _customerSearchResults,
          onSearchCustomers: _searchCustomers,
          onSelectCustomer: _selectCustomer,
          onNewCustomer: ([String? initialName]) {
            showDialog(context: context, builder: (_) => CustomerEntryDialog(initialName: initialName)).then((c) {
              if (c != null) _selectCustomer(c as Customer);
            });
          },
          searchQuery: _searchQuery,
          productSearchController: _productSearchController,
          productSearchFocus: _productSearchFocus,
          onSearchChanged: (val) => setState(() { _selectedProductIndex = 0; }),
          onClearSearch: () => setState(() { _productSearchController.clear(); _selectedProductIndex = 0; _productSearchFocus.requestFocus(); }),
          onNewSale: _newSale,
          onClearCustomer: _clearCustomer,
        );

        final productTable = ProductTable(
          medicines: filteredMedicines,
          repo: repo,
          cart: cart,
          selectedIndex: _selectedProductIndex,
          scrollController: _productGridController,
          onAddProduct: (index) => _addProductToIndex(index, filteredMedicines),
        );

        final cartPanel = Focus(
          focusNode: _cartFocus,
          child: CartPanel(
            cart: cart,
            notifier: cartNotifier,
            paymentMode: _paymentMode,
            changeReturn: _changeReturn,
            amountReceivedController: _amountReceivedController,
            amountReceivedFocus: _amountReceivedFocus,
            selectedItemIndex: _selectedCartItemIndex,
            onClear: () => cartNotifier.clear(),
            onPaymentModeChanged: (mode) => setState(() => _paymentMode = mode),
            onAmountChanged: _calculateChange,
            onCheckout: _handleCheckout,
            onDiscountTap: () {},
          ),
        );

        if (isMobile) {
          return Column(children: [header, Expanded(child: productTable)]); // Simplified for mobile
        }

        return Column(
          children: [
            header,
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 5, child: productTable),
                  Container(width: 360, child: cartPanel),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

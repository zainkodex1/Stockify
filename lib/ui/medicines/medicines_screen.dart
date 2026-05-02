import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/repositories/medicine_repository.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';
import 'add_medicine_dialog.dart';

class MedicinesScreen extends ConsumerStatefulWidget {
  const MedicinesScreen({super.key});

  @override
  ConsumerState<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends ConsumerState<MedicinesScreen> {
  String _searchQuery = '';
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleAddProduct() {
    showDialog(
      context: context,
      builder: (context) => const AddProductDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicineRepo = ref.watch(medicineRepositoryProvider);

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF): const _FocusSearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): const _AddProductIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const _ClearSearchIntent(),
      },
      child: Actions(
        actions: {
          _FocusSearchIntent: CallbackAction<_FocusSearchIntent>(onInvoke: (_) {
            _searchFocus.requestFocus();
            return null;
          }),
          _AddProductIntent: CallbackAction<_AddProductIntent>(onInvoke: (_) {
            _handleAddProduct();
            return null;
          }),
          _ClearSearchIntent: CallbackAction<_ClearSearchIntent>(onInvoke: (_) {
            setState(() => _searchQuery = '');
            _searchFocus.requestFocus();
            return null;
          }),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: AppTheme.appBackground,
            appBar: AppBar(
              title: const Text('Inventory Management'),
              backgroundColor: AppTheme.surface,
              surfaceTintColor: Colors.transparent,
              actions: [
                OutlinedButton.icon(
                  onPressed: () => _importCsv(context, ref),
                  icon: const Icon(Icons.upload_file_rounded, size: 18),
                  label: const Text('Import CSV'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _handleAddProduct,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.royalBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: Column(
              children: [
                // Top Search & Filter Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    border: Border(bottom: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _searchFocus,
                          decoration: InputDecoration(
                            hintText: 'Search inventory by name, category or SKU... (Ctrl+F)',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            fillColor: AppTheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.r12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildFilterBadge('All Items', true),
                      const SizedBox(width: 8),
                      _buildFilterBadge('Low Stock', false),
                    ],
                  ),
                ),
                
                // Inventory Table
                Expanded(
                  child: StreamBuilder<List<MedicineWithStock>>(
                    stream: medicineRepo.watchMedicinesWithStock(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      var items = snapshot.data!;
                      if (_searchQuery.isNotEmpty) {
                        items = items.where((item) => 
                          item.medicine.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          (item.medicine.mainCategory.toLowerCase().contains(_searchQuery.toLowerCase()))
                        ).toList();
                      }

                      if (items.isEmpty) {
                        return _buildEmptyState();
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 900) {
                            return _buildDesktopTable(items, medicineRepo);
                          } else {
                            return _buildMobileList(items, medicineRepo);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBadge(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppTheme.royalBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.rPill),
        border: Border.all(color: active ? AppTheme.royalBlue : AppTheme.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDesktopTable(List<MedicineWithStock> items, MedicineRepository medicineRepo) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.r16),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: DataTable(
              headingRowHeight: 48,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 52,
              columnSpacing: 24,
              columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('PRODUCT NAME')),
            DataColumn(label: Text('CATEGORY')),
            DataColumn(label: Text('STOCK')),
            DataColumn(label: Text('UNIT PRICE')),
            DataColumn(label: Text('PACK INFO')),
            DataColumn(label: Text('ACTIONS')),
          ],
          rows: items.map((item) {
            final medicine = item.medicine;
            final isPack = item.packSize > 1;
            final packPrice = item.latestPrice * item.packSize;
            final isLowStock = item.totalQuantity <= medicine.minStock;
            
            return DataRow(cells: [
              DataCell(Text('#${medicine.id}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))),
              DataCell(Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              DataCell(_CategoryPill(label: medicine.mainCategory)),
              DataCell(_StockCell(qty: item.totalQuantity, isLow: isLowStock)),
              DataCell(Text('PKR ${item.latestPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700))),
              DataCell(isPack 
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PKR ${packPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('${item.packSize} units/pack', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    ],
                  )
                : const Text('—', style: TextStyle(color: AppTheme.textMuted))
              ),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: AppTheme.royalBlue, size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddProductDialog(medicine: medicine),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, color: AppTheme.redDanger, size: 18),
                    onPressed: () => medicineRepo.deleteMedicine(medicine.id),
                  ),
                ],
              )),
            ]);
          }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(List<MedicineWithStock> items, MedicineRepository medicineRepo) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final medicine = item.medicine;
        final isLowStock = item.totalQuantity <= medicine.minStock;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(medicine.mainCategory, style: const TextStyle(fontSize: 12)),
            trailing: _StockCell(qty: item.totalQuantity, isLow: isLowStock),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddProductDialog(medicine: medicine),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: AppTheme.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('No products matching your search', 
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _importCsv(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final input = file.openRead();
        final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

        final repo = ref.read(medicineRepositoryProvider);
        int count = 0;

        for (var i = 1; i < fields.length; i++) {
          final row = fields[i];
          if (row.length >= 2) {
            await repo.addMedicine(MedicinesCompanion(
              name: drift.Value(row[0].toString()),
              code: drift.Value(row[1].toString()),
              minStock: const drift.Value(10),
            ));
            count++;
          }
        }
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Imported $count products successfully'),
            backgroundColor: AppTheme.emeraldSuccess,
          ));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Import Failed: $e'),
          backgroundColor: AppTheme.redDanger,
        ));
      }
    }
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  const _CategoryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(AppTheme.rPill),
        border: Border.all(color: const Color(0xFFD0E7FF)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF0055CC), fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StockCell extends StatelessWidget {
  final int qty;
  final bool isLow;
  const _StockCell({required this.qty, required this.isLow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? AppTheme.dangerSurface : AppTheme.successSurface,
        borderRadius: BorderRadius.circular(AppTheme.r12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLow) const Icon(Icons.warning_amber_rounded, size: 14, color: AppTheme.redDanger),
          if (isLow) const SizedBox(width: 6),
          Text(
            qty.toString(),
            style: TextStyle(
              color: isLow ? AppTheme.redDanger : AppTheme.emeraldSuccess,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusSearchIntent extends Intent { const _FocusSearchIntent(); }
class _AddProductIntent extends Intent { const _AddProductIntent(); }
class _ClearSearchIntent extends Intent { const _ClearSearchIntent(); }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/sale_repository.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleRepo = ref.watch(saleRepositoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(
        title: const Text('Sales History'),
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Sale>>(
        stream: saleRepo.watchAllSales(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final sales = snapshot.data!;

          if (sales.isEmpty) return _buildEmptyState();

          return Column(
            children: [
              _buildSummaryHeader(sales),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return _buildDesktopTable(context, sales, saleRepo);
                    } else {
                      return _buildMobileList(context, sales, saleRepo);
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(List<Sale> sales) {
    final totalRevenue = sales.fold<double>(0, (s, sale) => s + sale.grandTotal);
    final todaySales = sales.where((s) => 
      DateFormat('yyyy-MM-dd').format(s.date) == DateFormat('yyyy-MM-dd').format(DateTime.now())
    ).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          _buildStatItem('Today\'s Sales', todaySales.toString(), Icons.today_rounded, AppTheme.royalBlue),
          const SizedBox(width: 32),
          _buildStatItem('Total Transactions', sales.length.toString(), Icons.receipt_long_rounded, AppTheme.tealAccent),
          const SizedBox(width: 32),
          _buildStatItem('Total Revenue', 'PKR ${totalRevenue.toStringAsFixed(0)}', Icons.payments_rounded, AppTheme.emeraldSuccess),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.r12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<Sale> sales, SaleRepository saleRepo) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.r16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 52,
          dataRowMaxHeight: 52,
          columns: const [
            DataColumn(label: Text('INVOICE #')),
            DataColumn(label: Text('DATE & TIME')),
            DataColumn(label: Text('ITEMS')),
            DataColumn(label: Text('PAYMENT')),
            DataColumn(label: Text('GRAND TOTAL')),
            DataColumn(label: Text('ACTIONS')),
          ],
          rows: sales.map((sale) {
            return DataRow(cells: [
              DataCell(Text(sale.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
              DataCell(Text(DateFormat('MMM dd, yyyy  •  HH:mm').format(sale.date), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
              DataCell(FutureBuilder<List<SaleItem>>(
                future: saleRepo.getSaleItems(sale.id),
                builder: (context, itemSnapshot) {
                  final count = itemSnapshot.data?.length ?? 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.infoSurface, borderRadius: BorderRadius.circular(AppTheme.rPill)),
                    child: Text('$count Items', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.royalBlue)),
                  );
                },
              )),
              DataCell(_buildPaymentBadge(sale.paymentMethod)),
              DataCell(Text('PKR ${sale.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.deepIndigo))),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.print_rounded, color: AppTheme.textSecondary, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reprinting available in Receipt Preview')));
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaymentBadge(String? method) {
    Color color = AppTheme.textSecondary;
    Color bg = AppTheme.surfaceVariant;
    
    if (method == 'Cash') { color = AppTheme.emeraldSuccess; bg = AppTheme.successSurface; }
    else if (method == 'Card') { color = AppTheme.royalBlue; bg = AppTheme.infoSurface; }
    else if (method == 'Online') { color = AppTheme.tealAccent; bg = const Color(0xFFF0FDFA); }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.rPill),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        method ?? 'Unknown',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<Sale> sales, SaleRepository saleRepo) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(sale.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(DateFormat('MMM dd, yyyy').format(sale.date)),
            trailing: Text('PKR ${sale.grandTotal.toStringAsFixed(0)}', 
              style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.deepIndigo)),
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
          Icon(Icons.history_rounded, size: 80, color: AppTheme.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('No sales history found', 
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

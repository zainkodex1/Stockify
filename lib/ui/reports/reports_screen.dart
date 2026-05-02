import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/sale_repository.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleRepo = ref.watch(saleRepositoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _exportReport(context, ref),
            icon: const Icon(Icons.file_download_rounded, size: 18),
            label: const Text('Export CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.infoSurface,
              foregroundColor: AppTheme.royalBlue,
              elevation: 0,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartCard(context, saleRepo),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Top Selling', 'Coming Soon', Icons.star_rounded, AppTheme.amberWarning)),
                const SizedBox(width: 24),
                Expanded(child: _buildSummaryCard('Customer Growth', 'Coming Soon', Icons.trending_up_rounded, AppTheme.emeraldSuccess)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, SaleRepository saleRepo) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.r20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weekly Sales Performance', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  Text('Revenue comparison for the last 7 days', 
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.infoSurface,
                  borderRadius: BorderRadius.circular(AppTheme.r12),
                ),
                child: const Text('Last 7 Days', 
                  style: TextStyle(color: AppTheme.royalBlue, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 300,
            child: StreamBuilder<List<Sale>>(
              stream: saleRepo.watchAllSales(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final sales = snapshot.data!;
                final groupedSales = _groupSalesByDate(sales);
                
                if (groupedSales.isEmpty) return _buildEmptyChart();

                final maxValue = groupedSales.values.reduce((a, b) => a > b ? a : b);

                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxValue == 0 ? 100 : maxValue * 1.3,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => AppTheme.primaryNavy,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            'PKR ${rod.toY.toStringAsFixed(0)}',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(DateFormat('dd MMM').format(date), 
                                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true, 
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) => Text(
                            value >= 1000 ? '${(value/1000).toStringAsFixed(1)}k' : value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(color: AppTheme.border, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: groupedSales.entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key.millisecondsSinceEpoch,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value, 
                            gradient: AppTheme.primaryButtonGradient,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.r20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 48, color: AppTheme.textMuted),
          SizedBox(height: 16),
          Text('No sales data available for this period', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Map<DateTime, double> _groupSalesByDate(List<Sale> sales) {
    final Map<DateTime, double> data = {};
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      data[date] = 0.0;
    }
    for (var sale in sales) {
      final date = DateTime(sale.date.year, sale.date.month, sale.date.day);
      if (data.containsKey(date)) {
        data[date] = data[date]! + sale.grandTotal;
      }
    }
    return data;
  }

  Future<void> _exportReport(BuildContext context, WidgetRef ref) async {
    try {
      final saleRepo = ref.read(saleRepositoryProvider);
      final sales = await saleRepo.getAllSales();
      
      List<List<dynamic>> rows = [];
      rows.add(['Invoice', 'Date', 'SubTotal', 'Discount', 'Tax', 'Total', 'Payment Method']);
      
      for (var sale in sales) {
        rows.add([
          sale.invoiceNumber,
          DateFormat('yyyy-MM-dd HH:mm').format(sale.date),
          sale.subTotal,
          sale.discount,
          sale.tax,
          sale.grandTotal,
          sale.paymentMethod ?? 'N/A'
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Sales Report',
        fileName: 'stockify_sales_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(csv);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Sales report exported successfully!'),
            backgroundColor: AppTheme.emeraldSuccess,
          ));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Export Failed: $e'),
          backgroundColor: AppTheme.redDanger,
        ));
      }
    }
  }
}

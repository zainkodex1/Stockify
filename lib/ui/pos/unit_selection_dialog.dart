import 'package:flutter/material.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';

class UnitSelectionDialog extends StatelessWidget {
  final Medicine medicine;
  final List<ProductUnit> units;

  const UnitSelectionDialog({
    super.key,
    required this.medicine,
    required this.units,
  });

  static Future<ProductUnit?> show(BuildContext context, Medicine medicine, List<ProductUnit> units) {
    return showDialog<ProductUnit>(
      context: context,
      builder: (context) => UnitSelectionDialog(medicine: medicine, units: units),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2_rounded, color: AppTheme.royalBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    medicine.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Select sale unit for this item',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: units.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final unit = units[index];
                  return _UnitCard(
                    unit: unit,
                    onTap: () => Navigator.pop(context, unit),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final ProductUnit unit;
  final VoidCallback onTap;

  const _UnitCard({required this.unit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.r12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.r12),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.royalBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.r8),
              ),
              child: const Icon(Icons.extension_rounded, color: AppTheme.royalBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.name,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  Text(
                    '1 ${unit.name} = ${unit.conversionFactor.toStringAsFixed(0)} Base Unit',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              'PKR ${unit.salePrice.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.deepIndigo, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

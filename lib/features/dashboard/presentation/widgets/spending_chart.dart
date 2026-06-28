import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/constants/expense_categories.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/theme/app_text_styles.dart';
import 'package:expense_tracker_pro/core/utils/currency_formatter.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/shared/widgets/section_header.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key, required this.expenses});

  final List<ExpenseEntity> expenses;

  Map<String, double> get _categoryTotals {
    final totals = <String, double>{};
    for (final e in expenses.where((e) => e.isExpense)) {
      totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amount;
    }
    return Map.fromEntries(
      totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = _categoryTotals;
    if (totals.isEmpty) return const SizedBox.shrink();

    final total = totals.values.fold(0.0, (s, v) => s + v);
    final sections = totals.entries.map((entry) {
      final cat = ExpenseCategories.findById(entry.key);
      final pct = total > 0 ? (entry.value / total * 100) : 0.0;
      return PieChartSectionData(
        value: entry.value,
        color: cat.color,
        radius: 48,
        title: '${pct.toStringAsFixed(0)}%',
        titleStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
        showTitle: pct >= 8,
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Spending by Category'),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: totals.entries.take(5).map((entry) {
                      final cat = ExpenseCategories.findById(entry.key);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: cat.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              cat.name.length > 12
                                  ? '${cat.name.substring(0, 12)}...'
                                  : cat.name,
                              style: AppTextStyles.labelSmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

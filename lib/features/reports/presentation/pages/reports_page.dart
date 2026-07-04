import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/constants/expense_categories.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/theme/app_text_styles.dart';
import 'package:expense_tracker_pro/core/utils/currency_formatter.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/features/reports/presentation/controllers/reports_controller.dart';
import 'package:expense_tracker_pro/shared/widgets/app_empty_widget.dart';
import 'package:expense_tracker_pro/shared/widgets/section_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsPage extends GetView<ReportsController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: <Widget>[
          Obx(
            () => PopupMenuButton<String>(
              icon: controller.isExporting.value
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_rounded),
              onSelected: (String v) {
                if (v == 'csv') controller.exportCsv();
                if (v == 'pdf') controller.exportPdf();
              },
              itemBuilder: (_) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'csv',
                  child: ListTile(
                    leading: Icon(Icons.table_chart_outlined),
                    title: Text('Export CSV'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'pdf',
                  child: ListTile(
                    leading: Icon(Icons.picture_as_pdf_outlined),
                    title: Text('Export PDF'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.expenses.isEmpty) {
          return const AppEmptyWidget(
            title: 'No data for this month',
            subtitle: 'Add transactions to see reports',
            icon: Icons.bar_chart_outlined,
          );
        }
        return ListView(
          padding: AppSpacing.screenPadding,
          children: <Widget>[
            _MonthSelector(controller: controller),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(controller: controller),
            const SizedBox(height: AppSpacing.md),
            _BarChartCard(controller: controller),
            const SizedBox(height: AppSpacing.md),
            _CategoryBreakdown(controller: controller),
          ],
        );
      }),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.controller});
  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () {
            final DateTime m = controller.selectedMonth.value;
            controller.changeMonth(DateTime(m.year, m.month - 1));
          },
        ),
        Obx(
          () => Text(
            AppDateUtils.formatMonthYear(controller.selectedMonth.value),
            style: context.textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: () {
            final DateTime m = controller.selectedMonth.value;
            if (!AppDateUtils.isSameMonth(m, DateTime.now())) {
              controller.changeMonth(DateTime(m.year, m.month + 1));
            }
          },
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.controller});
  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _SummaryCard(
          label: 'Income',
          amount: controller.totalIncome,
          color: AppColors.income,
          icon: Icons.arrow_downward_rounded,
        ),
        const SizedBox(width: AppSpacing.sm),
        _SummaryCard(
          label: 'Expenses',
          amount: controller.totalExpense,
          color: AppColors.expense,
          icon: Icons.arrow_upward_rounded,
        ),
        const SizedBox(width: AppSpacing.sm),
        _SummaryCard(
          label: 'Saved',
          amount: controller.savingsRate,
          color: AppColors.saving,
          icon: Icons.savings_rounded,
          isPercent: true,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    this.isPercent = false,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final bool isPercent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 8),
              Text(
                isPercent
                    ? '${amount.toStringAsFixed(1)}%'
                    : CurrencyFormatter.formatCompact(amount),
                style: AppTextStyles.amountMedium.copyWith(
                  color: color,
                  fontSize: 16,
                ),
              ),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({required this.controller});
  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    final Map<String, double> totals = controller.categoryTotals;
    if (totals.isEmpty) return const SizedBox.shrink();

    final List<MapEntry<String, double>> entries = totals.entries
        .take(6)
        .toList();
    final double maxVal = entries
        .map((MapEntry<String, double> e) => e.value)
        .reduce((double a, double b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionHeader(title: 'Top Spending Categories'),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxVal * 1.2,
                  barGroups: entries.asMap().entries.map((
                    MapEntry<int, MapEntry<String, double>> e,
                  ) {
                    final ExpenseCategory cat = ExpenseCategories.findById(
                      e.value.key,
                    );
                    return BarChartGroupData(
                      x: e.key,
                      barRods: <BarChartRodData>[
                        BarChartRodData(
                          toY: e.value.value,
                          color: cat.color,
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double v, _) {
                          final int idx = v.toInt();
                          if (idx >= entries.length) return const SizedBox();
                          final ExpenseCategory cat =
                              ExpenseCategories.findById(entries[idx].key);
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(cat.icon, size: 14, color: cat.color),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.controller});
  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    final Map<String, double> totals = controller.categoryTotals;
    final double total = totals.values.fold(0.0, (double s, double v) => s + v);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionHeader(title: 'Category Breakdown'),
            const SizedBox(height: AppSpacing.sm),
            ...totals.entries.map((MapEntry<String, double> entry) {
              final ExpenseCategory cat = ExpenseCategories.findById(entry.key);
              final double pct = total > 0 ? entry.value / total : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: cat.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                cat.name,
                                style: context.textTheme.bodyMedium,
                              ),
                              Text(
                                CurrencyFormatter.format(entry.value),
                                style: AppTextStyles.labelLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              backgroundColor: AppColors.grey200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                cat.color,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

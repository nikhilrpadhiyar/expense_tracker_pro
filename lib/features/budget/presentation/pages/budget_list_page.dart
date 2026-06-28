import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/constants/expense_categories.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/theme/app_text_styles.dart';
import 'package:expense_tracker_pro/core/utils/currency_formatter.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_pro/features/budget/presentation/controllers/budget_controller.dart';
import 'package:expense_tracker_pro/routes/app_pages.dart';
import 'package:expense_tracker_pro/shared/widgets/app_empty_widget.dart';

class BudgetListPage extends GetView<BudgetController> {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Get.toNamed(AppRoutes.addBudget),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.budgets.isEmpty) {
          return const AppEmptyWidget(
            title: 'No budgets set',
            subtitle: 'Tap + to set a category budget',
            icon: Icons.account_balance_wallet_outlined,
          );
        }
        return ListView.builder(
          padding: AppSpacing.screenPadding,
          itemCount: controller.budgets.length,
          itemBuilder: (_, i) => _BudgetCard(budget: controller.budgets[i]),
        );
      }),
    );
  }
}

class _BudgetCard extends GetView<BudgetController> {
  const _BudgetCard({required this.budget});
  final BudgetEntity budget;

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategories.findById(budget.categoryId);
    final statusColor = budget.isExceeded
        ? AppColors.expense
        : budget.isNearLimit
            ? AppColors.warning
            : AppColors.success;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cat.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(cat.icon, color: cat.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cat.name, style: context.textTheme.titleMedium),
                      Text(
                        '${CurrencyFormatter.format(budget.spent)} of '
                        '${CurrencyFormatter.format(budget.limit)}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(budget.remaining.abs()),
                      style: AppTextStyles.amountMedium.copyWith(
                        color: statusColor,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      budget.isExceeded ? 'Exceeded' : 'Remaining',
                      style:
                          AppTextStyles.labelSmall.copyWith(color: statusColor),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.grey400, size: 20),
                  onPressed: () => controller.deleteBudget(budget.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: budget.percentUsed,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0', style: AppTextStyles.labelSmall),
                Text(
                  '${(budget.percentUsed * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.labelSmall.copyWith(color: statusColor),
                ),
                Text(
                  CurrencyFormatter.formatCompact(budget.limit),
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

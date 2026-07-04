import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/widgets/expense_list_tile.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/widgets/spending_chart.dart';
import 'package:expense_tracker_pro/shared/widgets/app_empty_widget.dart';
import 'package:expense_tracker_pro/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: controller.loadExpenses,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(child: _Header(controller: controller)),
                SliverToBoxAdapter(
                  child: BalanceCard(
                    balance: controller.balance,
                    income: controller.totalIncome,
                    expense: controller.totalExpense,
                  ),
                ),
                if (controller.expenses.isNotEmpty) ...<Widget>[
                  SliverToBoxAdapter(
                    child: SpendingChart(expenses: controller.expenses),
                  ),
                ],
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Recent Transactions',
                    action: controller.expenses.length > 5
                        ? TextButton(
                            onPressed: () {},
                            child: const Text('See All'),
                          )
                        : null,
                  ),
                ),
                if (controller.expenses.isEmpty)
                  const SliverToBoxAdapter(
                    child: AppEmptyWidget(
                      title: 'No transactions yet',
                      subtitle: 'Tap + to add your first expense',
                      icon: Icons.receipt_long_outlined,
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int i) => ExpenseListTile(
                        expense: controller.recentExpenses[i],
                      ),
                      childCount: controller.recentExpenses.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hello, ${controller.userName} 👋',
                style: context.textTheme.titleMedium,
              ),
              Obx(
                () => Text(
                  AppDateUtils.formatMonthYear(controller.selectedMonth.value),
                  style: context.textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: AppColors.primary.withAlpha(30),
            child: const Icon(Icons.person_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

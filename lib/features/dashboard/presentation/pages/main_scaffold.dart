import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/features/budget/presentation/pages/budget_list_page.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:expense_tracker_pro/features/expense/presentation/controllers/expense_controller.dart';
import 'package:expense_tracker_pro/features/expense/presentation/pages/add_expense_page.dart';
import 'package:expense_tracker_pro/features/reports/presentation/pages/reports_page.dart';
import 'package:expense_tracker_pro/features/settings/presentation/pages/settings_page.dart';
import 'package:expense_tracker_pro/routes/app_pages.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final navIndex = 0.obs;

    final pages = [
      const DashboardPage(),
      const BudgetListPage(),
      const ReportsPage(),
      const SettingsPage(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(index: navIndex.value, children: pages),
        floatingActionButton: navIndex.value == 0
            ? FloatingActionButton.extended(
                onPressed: () {
                  if (Get.isRegistered<ExpenseController>()) {
                    Get.find<ExpenseController>().populateForEdit(
                      // reset form by navigating to fresh add page
                      Get.find<ExpenseController>().titleController.clear != null
                          ? throw UnimplementedError()
                          : throw UnimplementedError(),
                    );
                  }
                  Get.toNamed(AppRoutes.addExpense);
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add'),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navIndex.value,
          onTap: (i) => navIndex.value = i,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

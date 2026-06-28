import 'package:get/get.dart';
import 'package:expense_tracker_pro/features/auth/presentation/controllers/auth_binding.dart';
import 'package:expense_tracker_pro/features/auth/presentation/pages/login_page.dart';
import 'package:expense_tracker_pro/features/auth/presentation/pages/register_page.dart';
import 'package:expense_tracker_pro/features/auth/presentation/pages/splash_page.dart';
import 'package:expense_tracker_pro/features/budget/presentation/controllers/budget_binding.dart';
import 'package:expense_tracker_pro/features/budget/presentation/pages/add_budget_page.dart';
import 'package:expense_tracker_pro/features/budget/presentation/pages/budget_list_page.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:expense_tracker_pro/features/expense/presentation/controllers/expense_binding.dart';
import 'package:expense_tracker_pro/features/expense/presentation/pages/add_expense_page.dart';
import 'package:expense_tracker_pro/features/reports/presentation/controllers/reports_binding.dart';
import 'package:expense_tracker_pro/features/reports/presentation/pages/reports_page.dart';
import 'package:expense_tracker_pro/features/settings/presentation/controllers/settings_binding.dart';
import 'package:expense_tracker_pro/features/settings/presentation/pages/settings_page.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/pages/main_scaffold.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScaffold(),
      bindings: [DashboardBinding(), ExpenseBinding(), BudgetBinding()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addExpense,
      page: () => const AddExpensePage(),
      binding: ExpenseBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.budgets,
      page: () => const BudgetListPage(),
      binding: BudgetBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addBudget,
      page: () => const AddBudgetPage(),
      binding: BudgetBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsPage(),
      binding: ReportsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

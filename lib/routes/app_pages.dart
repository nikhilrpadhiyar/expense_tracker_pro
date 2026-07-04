import 'package:expense_tracker_pro/features/auth/presentation/controllers/auth_binding.dart';
import 'package:expense_tracker_pro/features/auth/presentation/pages/login_page.dart';
import 'package:expense_tracker_pro/features/auth/presentation/pages/register_page.dart';
import 'package:expense_tracker_pro/features/auth/presentation/pages/splash_page.dart';
import 'package:expense_tracker_pro/features/budget/presentation/controllers/budget_binding.dart';
import 'package:expense_tracker_pro/features/budget/presentation/pages/add_budget_page.dart';
import 'package:expense_tracker_pro/features/budget/presentation/pages/budget_list_page.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/pages/main_scaffold.dart';
import 'package:expense_tracker_pro/features/expense/presentation/controllers/expense_binding.dart';
import 'package:expense_tracker_pro/features/expense/presentation/pages/add_expense_page.dart';
import 'package:expense_tracker_pro/features/reports/presentation/controllers/reports_binding.dart';
import 'package:expense_tracker_pro/features/reports/presentation/pages/reports_page.dart';
import 'package:expense_tracker_pro/features/settings/presentation/controllers/settings_binding.dart';
import 'package:expense_tracker_pro/features/settings/presentation/pages/settings_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.main,
      page: () => const MainScaffold(),
      bindings: <Bindings>[
        DashboardBinding(),
        ExpenseBinding(),
        BudgetBinding(),
      ],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.addExpense,
      page: () => const AddExpensePage(),
      binding: ExpenseBinding(),
      transition: Transition.downToUp,
    ),
    GetPage<dynamic>(
      name: AppRoutes.budgets,
      page: () => const BudgetListPage(),
      binding: BudgetBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.addBudget,
      page: () => const AddBudgetPage(),
      binding: BudgetBinding(),
      transition: Transition.downToUp,
    ),
    GetPage<dynamic>(
      name: AppRoutes.reports,
      page: () => const ReportsPage(),
      binding: ReportsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

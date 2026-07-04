part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String addExpense = '/add-expense';
  static const String editExpense = '/edit-expense';
  static const String expenseDetail = '/expense-detail';
  static const String budgets = '/budgets';
  static const String addBudget = '/add-budget';
  static const String reports = '/reports';
  static const String settings = '/settings';
}

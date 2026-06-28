part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const addExpense = '/add-expense';
  static const editExpense = '/edit-expense';
  static const expenseDetail = '/expense-detail';
  static const budgets = '/budgets';
  static const addBudget = '/add-budget';
  static const reports = '/reports';
  static const settings = '/settings';
}

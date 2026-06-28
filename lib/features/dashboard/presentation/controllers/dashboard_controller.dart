import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';

class DashboardController extends GetxController {
  DashboardController(this._getExpenses);
  final GetExpensesUseCase _getExpenses;

  final expenses = <ExpenseEntity>[].obs;
  final isLoading = false.obs;
  final selectedMonth = DateTime.now().obs;

  double get totalIncome => expenses
      .where((e) => e.isIncome)
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => expenses
      .where((e) => e.isExpense)
      .fold(0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;

  List<ExpenseEntity> get recentExpenses => expenses.take(5).toList();

  String get userName =>
      FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ??
      'User';

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    isLoading.value = true;
    final month = selectedMonth.value;
    final result = await _getExpenses(
      from: AppDateUtils.startOfMonthFor(month.year, month.month),
      to: AppDateUtils.endOfMonthFor(month.year, month.month),
    );
    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (list) => expenses.assignAll(list),
    );
    isLoading.value = false;
  }

  void changeMonth(DateTime month) {
    selectedMonth.value = month;
    loadExpenses();
  }
}

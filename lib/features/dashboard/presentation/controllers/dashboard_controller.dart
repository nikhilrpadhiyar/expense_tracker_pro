import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  DashboardController(this._getExpenses);
  final GetExpensesUseCase _getExpenses;

  final RxList<ExpenseEntity> expenses = <ExpenseEntity>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  double get totalIncome => expenses
      .where((ExpenseEntity e) => e.isIncome)
      .fold(0, (double sum, ExpenseEntity e) => sum + e.amount);

  double get totalExpense => expenses
      .where((ExpenseEntity e) => e.isExpense)
      .fold(0, (double sum, ExpenseEntity e) => sum + e.amount);

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
    final DateTime month = selectedMonth.value;
    final Either<Failure, List<ExpenseEntity>> result = await _getExpenses(
      from: AppDateUtils.startOfMonthFor(month.year, month.month),
      to: AppDateUtils.endOfMonthFor(month.year, month.month),
    );
    result.fold(
      (Failure f) => Get.snackbar('Error', f.message),
      (List<ExpenseEntity> list) => expenses.assignAll(list),
    );
    isLoading.value = false;
  }

  void changeMonth(DateTime month) {
    selectedMonth.value = month;
    loadExpenses();
  }
}

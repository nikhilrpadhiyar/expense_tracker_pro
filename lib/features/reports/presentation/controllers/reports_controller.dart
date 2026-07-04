import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/core/services/export_service.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  ReportsController(this._getExpenses);
  final GetExpensesUseCase _getExpenses;

  final RxList<ExpenseEntity> expenses = <ExpenseEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isExporting = false.obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  double get totalIncome => expenses
      .where((ExpenseEntity e) => e.isIncome)
      .fold(0, (double s, ExpenseEntity e) => s + e.amount);

  double get totalExpense => expenses
      .where((ExpenseEntity e) => e.isExpense)
      .fold(0, (double s, ExpenseEntity e) => s + e.amount);

  double get savingsRate {
    if (totalIncome == 0) return 0;
    return ((totalIncome - totalExpense) / totalIncome * 100).clamp(0, 100);
  }

  Map<String, double> get categoryTotals {
    final Map<String, double> totals = <String, double>{};
    for (final ExpenseEntity e in expenses.where(
      (ExpenseEntity e) => e.isExpense,
    )) {
      totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amount;
    }
    return Map<String, double>.fromEntries(
      totals.entries.toList()..sort(
        (MapEntry<String, double> a, MapEntry<String, double> b) =>
            b.value.compareTo(a.value),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadReport();
  }

  Future<void> loadReport() async {
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
    loadReport();
  }

  Future<void> exportCsv() async {
    isExporting.value = true;
    try {
      await ExportService.instance.exportToCsv(expenses);
    } catch (e) {
      Get.snackbar('Export Failed', e.toString());
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> exportPdf() async {
    isExporting.value = true;
    try {
      await ExportService.instance.exportToPdf(
        expenses: expenses,
        month: AppDateUtils.formatMonthYear(selectedMonth.value),
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        currency: 'USD',
      );
    } catch (e) {
      Get.snackbar('Export Failed', e.toString());
    } finally {
      isExporting.value = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/controllers/dashboard_controller.dart';

class ExpenseController extends GetxController {
  ExpenseController({
    required AddExpenseUseCase addExpense,
    required UpdateExpenseUseCase updateExpense,
    required DeleteExpenseUseCase deleteExpense,
    required GetExpensesUseCase getExpenses,
  })  : _add = addExpense,
        _update = updateExpense,
        _delete = deleteExpense,
        _get = getExpenses;

  final AddExpenseUseCase _add;
  final UpdateExpenseUseCase _update;
  final DeleteExpenseUseCase _delete;
  final GetExpensesUseCase _get;

  final isLoading = false.obs;
  final selectedType = ExpenseType.expense.obs;
  final selectedCategory = 'food'.obs;
  final selectedDate = DateTime.now().obs;

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void setType(ExpenseType type) => selectedType.value = type;
  void setCategory(String id) => selectedCategory.value = id;
  void setDate(DateTime date) => selectedDate.value = date;

  Future<void> saveExpense({ExpenseEntity? existing}) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final expense = ExpenseEntity(
      id: existing?.id ?? const Uuid().v4(),
      title: titleController.text.trim(),
      amount: double.parse(amountController.text.trim()),
      categoryId: selectedCategory.value,
      date: selectedDate.value,
      type: selectedType.value,
      note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
      isSynced: false,
    );

    final result = existing != null
        ? await _update(expense)
        : await _add(expense);

    isLoading.value = false;

    result.fold(
      (f) => Get.snackbar('Error', f.message,
          snackPosition: SnackPosition.BOTTOM),
      (_) {
        _refreshDashboard();
        Get.back();
        Get.snackbar(
          existing != null ? 'Updated' : 'Added',
          'Expense saved successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primaryContainer,
        );
      },
    );
  }

  Future<void> deleteExpense(String id) async {
    final result = await _delete(id);
    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (_) {
        _refreshDashboard();
        Get.snackbar('Deleted', 'Expense removed.',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  void populateForEdit(ExpenseEntity expense) {
    titleController.text = expense.title;
    amountController.text = expense.amount.toStringAsFixed(2);
    noteController.text = expense.note ?? '';
    selectedType.value = expense.type;
    selectedCategory.value = expense.categoryId;
    selectedDate.value = expense.date;
  }

  void _refreshDashboard() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadExpenses();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}

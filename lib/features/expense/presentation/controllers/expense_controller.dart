import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ExpenseController extends GetxController {
  ExpenseController({
    required AddExpenseUseCase addExpense,
    required UpdateExpenseUseCase updateExpense,
    required DeleteExpenseUseCase deleteExpense,
    required GetExpensesUseCase getExpenses,
  }) : _add = addExpense,
       _update = updateExpense,
       _delete = deleteExpense;

  final AddExpenseUseCase _add;
  final UpdateExpenseUseCase _update;
  final DeleteExpenseUseCase _delete;

  final RxBool isLoading = false.obs;
  final Rx<ExpenseType> selectedType = ExpenseType.expense.obs;
  final RxString selectedCategory = 'food'.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setType(ExpenseType type) => selectedType.value = type;
  void setCategory(String id) => selectedCategory.value = id;
  void setDate(DateTime date) => selectedDate.value = date;

  Future<void> saveExpense({ExpenseEntity? existing}) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final ExpenseEntity expense = ExpenseEntity(
      id: existing?.id ?? const Uuid().v4(),
      title: titleController.text.trim(),
      amount: double.parse(amountController.text.trim()),
      categoryId: selectedCategory.value,
      date: selectedDate.value,
      type: selectedType.value,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      isSynced: false,
    );

    final Either<Failure, ExpenseEntity> result = existing != null
        ? await _update(expense)
        : await _add(expense);

    isLoading.value = false;

    result.fold(
      (Failure f) =>
          Get.snackbar('Error', f.message, snackPosition: SnackPosition.BOTTOM),
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
    final Either<Failure, void> result = await _delete(id);
    result.fold((Failure f) => Get.snackbar('Error', f.message), (_) {
      _refreshDashboard();
      Get.snackbar(
        'Deleted',
        'Expense removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
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

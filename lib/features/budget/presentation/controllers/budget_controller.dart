import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_tracker_pro/core/services/notification_service.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_pro/features/budget/domain/repositories/budget_repository.dart';

class BudgetController extends GetxController {
  BudgetController(this._repository);
  final BudgetRepository _repository;

  final budgets = <BudgetEntity>[].obs;
  final isLoading = false.obs;
  final selectedMonth = DateTime.now().obs;

  final selectedCategory = 'food'.obs;
  final limitController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    isLoading.value = true;
    final month = selectedMonth.value;
    final result = await _repository.getBudgetsWithSpending(
      month: month.month,
      year: month.year,
    );
    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (list) {
        budgets.assignAll(list);
        _checkBudgetAlerts(list);
      },
    );
    isLoading.value = false;
  }

  Future<void> saveBudget() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    final month = selectedMonth.value;
    final budget = BudgetEntity(
      id: const Uuid().v4(),
      categoryId: selectedCategory.value,
      limit: double.parse(limitController.text.trim()),
      month: month.month,
      year: month.year,
    );

    final result = await _repository.saveBudget(budget);
    isLoading.value = false;

    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (_) {
        loadBudgets();
        Get.back();
        Get.snackbar('Success', 'Budget saved.',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> deleteBudget(String id) async {
    final result = await _repository.deleteBudget(id);
    result.fold(
      (f) => Get.snackbar('Error', f.message),
      (_) => loadBudgets(),
    );
  }

  void _checkBudgetAlerts(List<BudgetEntity> budgets) {
    for (final b in budgets) {
      if (b.isNearLimit || b.isExceeded) {
        NotificationService.instance.showBudgetAlert(
          categoryName: b.categoryId,
          spent: b.spent,
          budget: b.limit,
        );
      }
    }
  }

  @override
  void onClose() {
    limitController.dispose();
    super.onClose();
  }
}

import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/core/services/notification_service.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_pro/features/budget/domain/repositories/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class BudgetController extends GetxController {
  BudgetController(this._repository);
  final BudgetRepository _repository;

  final RxList<BudgetEntity> budgets = <BudgetEntity>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  final RxString selectedCategory = 'food'.obs;
  final TextEditingController limitController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    isLoading.value = true;
    final DateTime month = selectedMonth.value;
    final Either<Failure, List<BudgetEntity>> result = await _repository
        .getBudgetsWithSpending(month: month.month, year: month.year);
    result.fold((Failure f) => Get.snackbar('Error', f.message), (
      List<BudgetEntity> list,
    ) {
      budgets.assignAll(list);
      _checkBudgetAlerts(list);
    });
    isLoading.value = false;
  }

  Future<void> saveBudget() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    final DateTime month = selectedMonth.value;
    final BudgetEntity budget = BudgetEntity(
      id: const Uuid().v4(),
      categoryId: selectedCategory.value,
      limit: double.parse(limitController.text.trim()),
      month: month.month,
      year: month.year,
    );

    final Either<Failure, BudgetEntity> result = await _repository.saveBudget(
      budget,
    );
    isLoading.value = false;

    result.fold((Failure f) => Get.snackbar('Error', f.message), (_) {
      loadBudgets();
      Get.back();
      Get.snackbar(
        'Success',
        'Budget saved.',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> deleteBudget(String id) async {
    final Either<Failure, void> result = await _repository.deleteBudget(id);
    result.fold(
      (Failure f) => Get.snackbar('Error', f.message),
      (_) => loadBudgets(),
    );
  }

  void _checkBudgetAlerts(List<BudgetEntity> budgets) {
    for (final BudgetEntity b in budgets) {
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

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:expense_tracker_pro/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_pro/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:expense_tracker_pro/features/budget/presentation/controllers/budget_controller.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';

class BudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetLocalDataSource>(
      () => BudgetLocalDataSourceImpl(
        Hive.box<BudgetModel>(AppConstants.boxBudgets),
      ),
      fenix: true,
    );

    if (!Get.isRegistered<ExpenseLocalDataSource>()) {
      Get.lazyPut<ExpenseLocalDataSource>(
        () => ExpenseLocalDataSourceImpl(
          Hive.box<ExpenseModel>(AppConstants.boxExpenses),
        ),
        fenix: true,
      );
    }

    Get.lazyPut<BudgetRepositoryImpl>(
      () => BudgetRepositoryImpl(
        budgetLocal: Get.find<BudgetLocalDataSource>(),
        expenseLocal: Get.find<ExpenseLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => BudgetController(Get.find<BudgetRepositoryImpl>()),
    );
  }
}

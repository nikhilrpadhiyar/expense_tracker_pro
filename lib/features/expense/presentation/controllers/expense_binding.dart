import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:expense_tracker_pro/features/expense/presentation/controllers/expense_controller.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseLocalDataSource>(
      () => ExpenseLocalDataSourceImpl(
        Hive.box<ExpenseModel>(AppConstants.boxExpenses),
      ),
      fenix: true,
    );

    Get.lazyPut<ExpenseRemoteDataSource>(
      () => ExpenseRemoteDataSourceImpl(FirebaseFirestore.instance),
      fenix: true,
    );

    Get.lazyPut<ExpenseRepositoryImpl>(
      () => ExpenseRepositoryImpl(
        local: Get.find<ExpenseLocalDataSource>(),
        remote: Get.find<ExpenseRemoteDataSource>(),
      ),
      fenix: true,
    );

    final ExpenseRepositoryImpl repo = Get.find<ExpenseRepositoryImpl>();

    Get.lazyPut(() => AddExpenseUseCase(repo), fenix: true);
    Get.lazyPut(() => UpdateExpenseUseCase(repo), fenix: true);
    Get.lazyPut(() => DeleteExpenseUseCase(repo), fenix: true);
    Get.lazyPut(() => GetExpensesUseCase(repo), fenix: true);

    Get.lazyPut(
      () => ExpenseController(
        addExpense: Get.find<AddExpenseUseCase>(),
        updateExpense: Get.find<UpdateExpenseUseCase>(),
        deleteExpense: Get.find<DeleteExpenseUseCase>(),
        getExpenses: Get.find<GetExpensesUseCase>(),
      ),
    );
  }
}

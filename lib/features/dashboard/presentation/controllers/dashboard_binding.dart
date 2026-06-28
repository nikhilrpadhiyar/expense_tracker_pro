import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_pro/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpenseLocalDataSource>()) {
      Get.lazyPut<ExpenseLocalDataSource>(
        () => ExpenseLocalDataSourceImpl(
          Hive.box<ExpenseModel>(AppConstants.boxExpenses),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ExpenseRemoteDataSource>()) {
      Get.lazyPut<ExpenseRemoteDataSource>(
        () => ExpenseRemoteDataSourceImpl(FirebaseFirestore.instance),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ExpenseRepositoryImpl>()) {
      Get.lazyPut<ExpenseRepositoryImpl>(
        () => ExpenseRepositoryImpl(
          local: Get.find<ExpenseLocalDataSource>(),
          remote: Get.find<ExpenseRemoteDataSource>(),
        ),
        fenix: true,
      );
    }

    Get.lazyPut(
      () => GetExpensesUseCase(Get.find<ExpenseRepositoryImpl>()),
      fenix: true,
    );

    Get.lazyPut(
      () => DashboardController(Get.find<GetExpensesUseCase>()),
    );
  }
}

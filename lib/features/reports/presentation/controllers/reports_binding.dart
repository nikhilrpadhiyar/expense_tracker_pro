import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker_pro/features/expense/domain/usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_pro/features/reports/presentation/controllers/reports_controller.dart';

class ReportsBinding extends Bindings {
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
    Get.lazyPut(
      () => GetExpensesUseCase(Get.find<ExpenseRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ReportsController(Get.find<GetExpensesUseCase>()),
    );
  }
}

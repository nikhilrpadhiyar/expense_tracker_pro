import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl({
    required ExpenseLocalDataSource local,
    required ExpenseRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final ExpenseLocalDataSource _local;
  final ExpenseRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    ExpenseType? type,
  }) async {
    try {
      final List<ExpenseModel> models = _local.getExpensesFiltered(
        from: from,
        to: to,
        categoryId: categoryId,
        type: type,
      );
      return Right<Failure, List<ExpenseEntity>>(
        models.map((ExpenseModel m) => m.toEntity()).toList(),
      );
    } on CacheException catch (e) {
      return Left<Failure, List<ExpenseEntity>>(
        CacheFailure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(
    ExpenseEntity expense,
  ) async {
    try {
      final ExpenseModel model = ExpenseModel.fromEntity(expense);
      await _local.saveExpense(model);
      return Right<Failure, ExpenseEntity>(expense);
    } on CacheException catch (e) {
      return Left<Failure, ExpenseEntity>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> updateExpense(
    ExpenseEntity expense,
  ) async {
    try {
      final ExpenseModel model = ExpenseModel.fromEntity(
        expense.copyWith(isSynced: false),
      );
      await _local.saveExpense(model);
      return Right<Failure, ExpenseEntity>(expense);
    } on CacheException catch (e) {
      return Left<Failure, ExpenseEntity>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await _local.deleteExpense(id);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> syncToCloud(String userId) async {
    try {
      final List<ExpenseModel> unsynced = _local.getUnsynced();
      if (unsynced.isNotEmpty) {
        await _remote.uploadExpenses(unsynced, userId);
        await _local.markSynced(
          unsynced.map((ExpenseModel e) => e.id).toList(),
        );
      }
      return const Right<Failure, void>(null);
    } on SyncException catch (e) {
      return Left<Failure, void>(SyncFailure(message: e.message));
    }
  }

  @override
  Stream<List<ExpenseEntity>> watchExpenses() {
    return _local.watch().map((_) {
      return _local
          .getAllExpenses()
          .map((ExpenseModel m) => m.toEntity())
          .toList();
    });
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCategoryTotals({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final List<ExpenseModel> expenses = _local.getExpensesFiltered(
        from: from,
        to: to,
        type: ExpenseType.expense,
      );
      final Map<String, double> totals = <String, double>{};
      for (final ExpenseModel e in expenses) {
        totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amount;
      }
      return Right<Failure, Map<String, double>>(totals);
    } on CacheException catch (e) {
      return Left<Failure, Map<String, double>>(
        CacheFailure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, double>> getTotalForPeriod({
    required DateTime from,
    required DateTime to,
    required ExpenseType type,
  }) async {
    try {
      final List<ExpenseModel> expenses = _local.getExpensesFiltered(
        from: from,
        to: to,
        type: type,
      );
      final double total = expenses.fold<double>(
        0,
        (double sum, ExpenseModel e) => sum + e.amount,
      );
      return Right<Failure, double>(total);
    } on CacheException catch (e) {
      return Left<Failure, double>(CacheFailure(message: e.message));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/repositories/expense_repository.dart';
import 'package:hive/hive.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl({
    required ExpenseLocalDataSource local,
    required ExpenseRemoteDataSource remote,
  })  : _local = local,
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
      final models = _local.getExpensesFiltered(
        from: from,
        to: to,
        categoryId: categoryId,
        type: type,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(
    ExpenseEntity expense,
  ) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      await _local.saveExpense(model);
      return Right(expense);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> updateExpense(
    ExpenseEntity expense,
  ) async {
    try {
      final model = ExpenseModel.fromEntity(expense.copyWith(isSynced: false));
      await _local.saveExpense(model);
      return Right(expense);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await _local.deleteExpense(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> syncToCloud(String userId) async {
    try {
      final unsynced = _local.getUnsynced();
      if (unsynced.isNotEmpty) {
        await _remote.uploadExpenses(unsynced, userId);
        await _local.markSynced(unsynced.map((e) => e.id).toList());
      }
      return const Right(null);
    } on SyncException catch (e) {
      return Left(SyncFailure(message: e.message));
    }
  }

  @override
  Stream<List<ExpenseEntity>> watchExpenses() {
    return _local.watch().map((_) {
      return _local.getAllExpenses().map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCategoryTotals({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final expenses = _local.getExpensesFiltered(
        from: from,
        to: to,
        type: ExpenseType.expense,
      );
      final totals = <String, double>{};
      for (final e in expenses) {
        totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amount;
      }
      return Right(totals);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalForPeriod({
    required DateTime from,
    required DateTime to,
    required ExpenseType type,
  }) async {
    try {
      final expenses = _local.getExpensesFiltered(from: from, to: to, type: type);
      final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
      return Right(total);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}

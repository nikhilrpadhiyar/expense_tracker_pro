import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    ExpenseType? type,
  });

  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense);

  Future<Either<Failure, ExpenseEntity>> updateExpense(ExpenseEntity expense);

  Future<Either<Failure, void>> deleteExpense(String id);

  Future<Either<Failure, void>> syncToCloud(String userId);

  Stream<List<ExpenseEntity>> watchExpenses();

  Future<Either<Failure, Map<String, double>>> getCategoryTotals({
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, double>> getTotalForPeriod({
    required DateTime from,
    required DateTime to,
    required ExpenseType type,
  });
}

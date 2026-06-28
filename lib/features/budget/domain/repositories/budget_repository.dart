import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetEntity>>> getBudgets({
    required int month,
    required int year,
  });

  Future<Either<Failure, BudgetEntity>> saveBudget(BudgetEntity budget);

  Future<Either<Failure, void>> deleteBudget(String id);

  Future<Either<Failure, List<BudgetEntity>>> getBudgetsWithSpending({
    required int month,
    required int year,
  });
}

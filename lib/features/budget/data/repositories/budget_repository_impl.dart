import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:expense_tracker_pro/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_pro/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl({
    required BudgetLocalDataSource budgetLocal,
    required ExpenseLocalDataSource expenseLocal,
  })  : _budgetLocal = budgetLocal,
        _expenseLocal = expenseLocal;

  final BudgetLocalDataSource _budgetLocal;
  final ExpenseLocalDataSource _expenseLocal;

  @override
  Future<Either<Failure, List<BudgetEntity>>> getBudgets({
    required int month,
    required int year,
  }) async {
    try {
      final models = _budgetLocal.getBudgetsForMonth(month, year);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BudgetEntity>> saveBudget(BudgetEntity budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);
      await _budgetLocal.saveBudget(model);
      return Right(budget);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await _budgetLocal.deleteBudget(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BudgetEntity>>> getBudgetsWithSpending({
    required int month,
    required int year,
  }) async {
    try {
      final budgets = _budgetLocal.getBudgetsForMonth(month, year);
      final from = DateTime(year, month);
      final to = DateTime(year, month + 1, 0, 23, 59, 59);

      final expenses = _expenseLocal.getExpensesFiltered(
        from: from,
        to: to,
        type: ExpenseType.expense,
      );

      final spendingByCategory = <String, double>{};
      for (final e in expenses) {
        spendingByCategory[e.categoryId] =
            (spendingByCategory[e.categoryId] ?? 0) + e.amount;
      }

      return Right(
        budgets
            .map((b) => b.toEntity(
                  spent: spendingByCategory[b.categoryId] ?? 0,
                ))
            .toList(),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}

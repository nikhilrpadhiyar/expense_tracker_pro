import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:expense_tracker_pro/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_tracker_pro/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl({
    required BudgetLocalDataSource budgetLocal,
    required ExpenseLocalDataSource expenseLocal,
  }) : _budgetLocal = budgetLocal,
       _expenseLocal = expenseLocal;

  final BudgetLocalDataSource _budgetLocal;
  final ExpenseLocalDataSource _expenseLocal;

  @override
  Future<Either<Failure, List<BudgetEntity>>> getBudgets({
    required int month,
    required int year,
  }) async {
    try {
      final List<BudgetModel> models = _budgetLocal.getBudgetsForMonth(
        month,
        year,
      );
      return Right<Failure, List<BudgetEntity>>(
        models.map((BudgetModel m) => m.toEntity()).toList(),
      );
    } on CacheException catch (e) {
      return Left<Failure, List<BudgetEntity>>(
        CacheFailure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, BudgetEntity>> saveBudget(BudgetEntity budget) async {
    try {
      final BudgetModel model = BudgetModel.fromEntity(budget);
      await _budgetLocal.saveBudget(model);
      return Right<Failure, BudgetEntity>(budget);
    } on CacheException catch (e) {
      return Left<Failure, BudgetEntity>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await _budgetLocal.deleteBudget(id);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BudgetEntity>>> getBudgetsWithSpending({
    required int month,
    required int year,
  }) async {
    try {
      final List<BudgetModel> budgets = _budgetLocal.getBudgetsForMonth(
        month,
        year,
      );
      final DateTime from = DateTime(year, month);
      final DateTime to = DateTime(year, month + 1, 0, 23, 59, 59);

      final List<ExpenseModel> expenses = _expenseLocal.getExpensesFiltered(
        from: from,
        to: to,
        type: ExpenseType.expense,
      );

      final Map<String, double> spendingByCategory = <String, double>{};
      for (final ExpenseModel e in expenses) {
        spendingByCategory[e.categoryId] =
            (spendingByCategory[e.categoryId] ?? 0) + e.amount;
      }

      return Right<Failure, List<BudgetEntity>>(
        budgets
            .map(
              (BudgetModel b) =>
                  b.toEntity(spent: spendingByCategory[b.categoryId] ?? 0),
            )
            .toList(),
      );
    } on CacheException catch (e) {
      return Left<Failure, List<BudgetEntity>>(
        CacheFailure(message: e.message),
      );
    }
  }
}

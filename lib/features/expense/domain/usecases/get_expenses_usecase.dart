import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/repositories/expense_repository.dart';

class GetExpensesUseCase {
  const GetExpensesUseCase(this._repository);
  final ExpenseRepository _repository;

  Future<Either<Failure, List<ExpenseEntity>>> call({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    ExpenseType? type,
  }) =>
      _repository.getExpenses(
        from: from,
        to: to,
        categoryId: categoryId,
        type: type,
      );
}

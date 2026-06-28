import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  const UpdateExpenseUseCase(this._repository);
  final ExpenseRepository _repository;

  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.updateExpense(expense);
}

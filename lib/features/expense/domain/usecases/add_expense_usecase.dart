import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:expense_tracker_pro/features/expense/domain/repositories/expense_repository.dart';

class AddExpenseUseCase {
  const AddExpenseUseCase(this._repository);
  final ExpenseRepository _repository;

  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity expense) =>
      _repository.addExpense(expense);
}

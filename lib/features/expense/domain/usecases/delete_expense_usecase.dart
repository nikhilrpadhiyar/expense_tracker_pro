import 'package:dartz/dartz.dart';
import 'package:expense_tracker_pro/core/error/failures.dart';
import 'package:expense_tracker_pro/features/expense/domain/repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  const DeleteExpenseUseCase(this._repository);
  final ExpenseRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteExpense(id);
}

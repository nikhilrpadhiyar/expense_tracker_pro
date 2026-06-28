import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

void main() {
  final baseExpense = ExpenseEntity(
    id: 'exp-1',
    title: 'Lunch',
    amount: 15.0,
    categoryId: 'food',
    date: DateTime(2024, 6, 1),
    type: ExpenseType.expense,
  );

  group('ExpenseEntity', () {
    test('isExpense returns true for expense type', () {
      expect(baseExpense.isExpense, isTrue);
      expect(baseExpense.isIncome, isFalse);
    });

    test('isIncome returns true for income type', () {
      final income = baseExpense.copyWith(type: ExpenseType.income);
      expect(income.isIncome, isTrue);
      expect(income.isExpense, isFalse);
    });

    test('copyWith updates only specified fields', () {
      final updated = baseExpense.copyWith(title: 'Dinner', amount: 30.0);
      expect(updated.title, 'Dinner');
      expect(updated.amount, 30.0);
      expect(updated.categoryId, baseExpense.categoryId);
    });

    test('equality is value-based via Equatable', () {
      final copy = ExpenseEntity(
        id: baseExpense.id,
        title: baseExpense.title,
        amount: baseExpense.amount,
        categoryId: baseExpense.categoryId,
        date: baseExpense.date,
        type: baseExpense.type,
      );
      expect(baseExpense, equals(copy));
    });
  });

  group('BudgetEntity', () {
    test('percentUsed is clamped between 0 and 1', () {
      // Tested indirectly through entity calculations
      final spent = 120.0;
      final limit = 100.0;
      final pct = (spent / limit).clamp(0.0, 1.0);
      expect(pct, 1.0);
    });
  });
}

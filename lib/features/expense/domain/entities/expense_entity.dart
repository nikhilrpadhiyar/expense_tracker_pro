import 'package:equatable/equatable.dart';

enum ExpenseType { expense, income }

class ExpenseEntity extends Equatable {
  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.type,
    this.note,
    this.receiptUrl,
    this.isSynced = false,
    this.userId,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final ExpenseType type;
  final String? note;
  final String? receiptUrl;
  final bool isSynced;
  final String? userId;

  bool get isExpense => type == ExpenseType.expense;
  bool get isIncome => type == ExpenseType.income;

  ExpenseEntity copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    ExpenseType? type,
    String? note,
    String? receiptUrl,
    bool? isSynced,
    String? userId,
  }) =>
      ExpenseEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        type: type ?? this.type,
        note: note ?? this.note,
        receiptUrl: receiptUrl ?? this.receiptUrl,
        isSynced: isSynced ?? this.isSynced,
        userId: userId ?? this.userId,
      );

  @override
  List<Object?> get props =>
      [id, title, amount, categoryId, date, type, note, isSynced];
}

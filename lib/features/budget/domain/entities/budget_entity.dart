import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  const BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.month,
    required this.year,
    this.spent = 0,
  });

  final String id;
  final String categoryId;
  final double limit;
  final int month;
  final int year;
  final double spent;

  double get remaining => limit - spent;
  double get percentUsed => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0;
  bool get isExceeded => spent > limit;
  bool get isNearLimit => percentUsed >= 0.8 && !isExceeded;

  BudgetEntity copyWith({
    String? id,
    String? categoryId,
    double? limit,
    int? month,
    int? year,
    double? spent,
  }) => BudgetEntity(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    limit: limit ?? this.limit,
    month: month ?? this.month,
    year: year ?? this.year,
    spent: spent ?? this.spent,
  );

  @override
  List<Object> get props => <Object>[id, categoryId, limit, month, year, spent];
}

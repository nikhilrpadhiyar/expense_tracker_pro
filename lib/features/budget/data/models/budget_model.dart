import 'package:hive/hive.dart';
import 'package:expense_tracker_pro/features/budget/domain/entities/budget_entity.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 1)
class BudgetModel extends HiveObject {
  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.month,
    required this.year,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double limit;

  @HiveField(3)
  final int month;

  @HiveField(4)
  final int year;

  factory BudgetModel.fromEntity(BudgetEntity entity) => BudgetModel(
        id: entity.id,
        categoryId: entity.categoryId,
        limit: entity.limit,
        month: entity.month,
        year: entity.year,
      );

  BudgetEntity toEntity({double spent = 0}) => BudgetEntity(
        id: id,
        categoryId: categoryId,
        limit: limit,
        month: month,
        year: year,
        spent: spent,
      );
}

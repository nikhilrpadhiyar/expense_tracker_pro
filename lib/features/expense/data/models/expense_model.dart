import 'package:hive/hive.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.typeIndex,
    this.note,
    this.receiptUrl,
    this.isSynced = false,
    this.userId,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final int typeIndex;

  @HiveField(6)
  final String? note;

  @HiveField(7)
  final String? receiptUrl;

  @HiveField(8)
  bool isSynced;

  @HiveField(9)
  final String? userId;

  ExpenseType get type => ExpenseType.values[typeIndex];

  factory ExpenseModel.fromEntity(ExpenseEntity entity) => ExpenseModel(
        id: entity.id,
        title: entity.title,
        amount: entity.amount,
        categoryId: entity.categoryId,
        date: entity.date,
        typeIndex: entity.type.index,
        note: entity.note,
        receiptUrl: entity.receiptUrl,
        isSynced: entity.isSynced,
        userId: entity.userId,
      );

  ExpenseEntity toEntity() => ExpenseEntity(
        id: id,
        title: title,
        amount: amount,
        categoryId: categoryId,
        date: date,
        type: type,
        note: note,
        receiptUrl: receiptUrl,
        isSynced: isSynced,
        userId: userId,
      );

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'title': title,
        'amount': amount,
        'categoryId': categoryId,
        'date': date.toIso8601String(),
        'typeIndex': typeIndex,
        'note': note,
        'receiptUrl': receiptUrl,
        'userId': userId,
        'isSynced': true,
      };

  factory ExpenseModel.fromFirestore(Map<String, dynamic> json) =>
      ExpenseModel(
        id: json['id'] as String,
        title: json['title'] as String,
        amount: (json['amount'] as num).toDouble(),
        categoryId: json['categoryId'] as String,
        date: DateTime.parse(json['date'] as String),
        typeIndex: json['typeIndex'] as int,
        note: json['note'] as String?,
        receiptUrl: json['receiptUrl'] as String?,
        isSynced: true,
        userId: json['userId'] as String?,
      );
}

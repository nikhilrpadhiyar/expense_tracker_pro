import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';

abstract class ExpenseLocalDataSource {
  Future<void> saveExpense(ExpenseModel model);
  Future<void> deleteExpense(String id);
  List<ExpenseModel> getAllExpenses();
  List<ExpenseModel> getExpensesFiltered({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    ExpenseType? type,
  });
  Stream<BoxEvent> watch();
  Future<void> markSynced(List<String> ids);
  List<ExpenseModel> getUnsynced();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  ExpenseLocalDataSourceImpl(this._box);

  final Box<ExpenseModel> _box;

  @override
  Future<void> saveExpense(ExpenseModel model) async {
    try {
      await _box.put(model.id, model);
    } catch (e) {
      throw CacheException(message: 'Failed to save expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete expense: $e');
    }
  }

  @override
  List<ExpenseModel> getAllExpenses() =>
      _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  @override
  List<ExpenseModel> getExpensesFiltered({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    ExpenseType? type,
  }) {
    final fromDate = from ?? DateTime(2000);
    final toDate = to ?? DateTime(2100);

    return _box.values.where((e) {
      final inRange =
          !e.date.isBefore(fromDate) && !e.date.isAfter(toDate);
      final matchesCategory =
          categoryId == null || e.categoryId == categoryId;
      final matchesType = type == null || e.type == type;
      return inRange && matchesCategory && matchesType;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Stream<BoxEvent> watch() => _box.watch();

  @override
  Future<void> markSynced(List<String> ids) async {
    for (final id in ids) {
      final model = _box.get(id);
      if (model != null) {
        model.isSynced = true;
        await model.save();
      }
    }
  }

  @override
  List<ExpenseModel> getUnsynced() =>
      _box.values.where((e) => !e.isSynced).toList();

  static Future<void> openBox() async {
    await Hive.openBox<ExpenseModel>(AppConstants.boxExpenses);
  }
}

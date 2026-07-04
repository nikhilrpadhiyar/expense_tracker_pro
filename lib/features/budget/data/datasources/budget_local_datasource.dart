import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/features/budget/data/models/budget_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BudgetLocalDataSource {
  Future<void> saveBudget(BudgetModel model);
  Future<void> deleteBudget(String id);
  List<BudgetModel> getBudgetsForMonth(int month, int year);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl(this._box);
  final Box<BudgetModel> _box;

  @override
  Future<void> saveBudget(BudgetModel model) async {
    try {
      await _box.put(model.id, model);
    } catch (e) {
      throw CacheException(message: 'Failed to save budget: $e');
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete budget: $e');
    }
  }

  @override
  List<BudgetModel> getBudgetsForMonth(int month, int year) => _box.values
      .where((BudgetModel b) => b.month == month && b.year == year)
      .toList();

  static Future<void> openBox() async {
    await Hive.openBox<BudgetModel>(AppConstants.boxBudgets);
  }
}

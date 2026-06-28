import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> uploadExpenses(List<ExpenseModel> expenses, String userId);
  Future<List<ExpenseModel>> fetchExpenses(String userId);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  ExpenseRemoteDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore.collection('users').doc(userId).collection('expenses');

  @override
  Future<void> uploadExpenses(
    List<ExpenseModel> expenses,
    String userId,
  ) async {
    try {
      final batch = _firestore.batch();
      for (final expense in expenses) {
        final doc = _collection(userId).doc(expense.id);
        batch.set(doc, expense.toFirestore());
      }
      await batch.commit();
    } catch (e) {
      throw SyncException(message: 'Failed to sync expenses: $e');
    }
  }

  @override
  Future<List<ExpenseModel>> fetchExpenses(String userId) async {
    try {
      final snapshot = await _collection(userId).get();
      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw SyncException(message: 'Failed to fetch remote expenses: $e');
    }
  }
}

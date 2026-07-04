import 'package:flutter/material.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
}

class ExpenseCategories {
  ExpenseCategories._();

  static const List<ExpenseCategory> all = <ExpenseCategory>[
    ExpenseCategory(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFF6B6B),
    ),
    ExpenseCategory(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car_rounded,
      color: Color(0xFF4ECDC4),
    ),
    ExpenseCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFFFE66D),
    ),
    ExpenseCategory(
      id: 'health',
      name: 'Health',
      icon: Icons.favorite_rounded,
      color: Color(0xFFFF8B94),
    ),
    ExpenseCategory(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie_rounded,
      color: Color(0xFFA8E6CF),
    ),
    ExpenseCategory(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF6C63FF),
    ),
    ExpenseCategory(
      id: 'education',
      name: 'Education',
      icon: Icons.school_rounded,
      color: Color(0xFF45B7D1),
    ),
    ExpenseCategory(
      id: 'travel',
      name: 'Travel',
      icon: Icons.flight_rounded,
      color: Color(0xFFFF9F43),
    ),
    ExpenseCategory(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.local_grocery_store_rounded,
      color: Color(0xFF54A0FF),
    ),
    ExpenseCategory(
      id: 'other',
      name: 'Other',
      icon: Icons.category_rounded,
      color: Color(0xFF8395A7),
    ),
  ];

  static ExpenseCategory findById(String id) =>
      all.firstWhere((ExpenseCategory c) => c.id == id, orElse: () => all.last);
}

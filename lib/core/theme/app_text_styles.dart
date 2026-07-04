import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'Poppins';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle amountLarge = TextStyle(
    fontFamily: _font,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static const TextStyle amountMedium = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
}

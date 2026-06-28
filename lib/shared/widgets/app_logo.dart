import 'package:flutter/material.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64, this.light = false});

  final double size;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: light ? AppColors.white.withAlpha(30) : AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: light ? AppColors.white : AppColors.white,
        size: size * 0.55,
      ),
    );
  }
}

import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const AppLogo(size: 80, light: true),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track. Budget. Grow.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white.withAlpha(200),
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

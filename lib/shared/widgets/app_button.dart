import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.width,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final RenderObjectWidget child = isLoading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: switch (variant) {
        AppButtonVariant.filled => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
        AppButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
        AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      },
    );
  }
}

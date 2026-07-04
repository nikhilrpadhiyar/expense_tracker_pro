import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: context.textTheme.titleMedium),
          if (action != null) action!,
        ],
      ),
    );
  }
}

extension _TextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

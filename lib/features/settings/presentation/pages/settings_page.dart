import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_pro/core/constants/app_spacing.dart';
import 'package:expense_tracker_pro/core/theme/app_colors.dart';
import 'package:expense_tracker_pro/features/settings/presentation/controllers/settings_controller.dart';
import 'package:expense_tracker_pro/shared/widgets/app_logo.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _SectionLabel('Appearance'),
          Obx(
            () => SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark'),
              value: controller.isDarkMode.value,
              onChanged: (_) => controller.toggleTheme(),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
          ),
          const Divider(),
          _SectionLabel('Currency'),
          Obx(
            () => Column(
              children: controller.currencies.map((c) {
                return RadioListTile<String>(
                  title: Text(c),
                  value: c,
                  groupValue: controller.selectedCurrency.value,
                  onChanged: (v) => controller.setCurrency(v!),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          _SectionLabel('Notifications'),
          Obx(
            () => SwitchListTile(
              title: const Text('Budget Alerts'),
              subtitle: const Text('Notify when nearing budget limits'),
              value: controller.notificationsEnabled.value,
              onChanged: (_) => controller.toggleNotifications(),
              secondary: const Icon(Icons.notifications_outlined),
            ),
          ),
          const Divider(),
          _SectionLabel('Account'),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.expense),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.expense),
            ),
            onTap: controller.signOut,
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Column(
              children: [
                const AppLogo(size: 40),
                const SizedBox(height: 8),
                Text(
                  'Expense Tracker Pro',
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  'Version 1.0.0',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.theme.colorScheme.primary,
        ),
      ),
    );
  }
}

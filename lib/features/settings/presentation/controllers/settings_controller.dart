import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/features/auth/presentation/controllers/auth_controller.dart';

class SettingsController extends GetxController {
  final _box = GetStorage();

  final isDarkMode = false.obs;
  final selectedCurrency = AppConstants.defaultCurrency.obs;
  final notificationsEnabled = true.obs;

  final currencies = ['USD', 'EUR', 'GBP', 'INR', 'JPY'];

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value =
        _box.read<String>(AppConstants.keyThemeMode) == 'dark';
    selectedCurrency.value =
        _box.read<String>(AppConstants.keyDefaultCurrency) ??
            AppConstants.defaultCurrency;
    notificationsEnabled.value =
        _box.read<bool>(AppConstants.keyNotificationsEnabled) ?? true;
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(
        isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    await _box.write(
      AppConstants.keyThemeMode,
      isDarkMode.value ? 'dark' : 'light',
    );
  }

  Future<void> setCurrency(String code) async {
    selectedCurrency.value = code;
    await _box.write(AppConstants.keyDefaultCurrency, code);
  }

  Future<void> toggleNotifications() async {
    notificationsEnabled.value = !notificationsEnabled.value;
    await _box.write(
      AppConstants.keyNotificationsEnabled,
      notificationsEnabled.value,
    );
  }

  void signOut() => Get.find<AuthController>().signOut();
}

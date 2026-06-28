class AppConstants {
  AppConstants._();

  static const String appName = 'Expense Tracker Pro';
  static const String appVersion = '1.0.0';

  // Hive box names
  static const String boxExpenses = 'expenses';
  static const String boxBudgets = 'budgets';
  static const String boxCategories = 'categories';
  static const String boxUser = 'user';
  static const String boxSettings = 'settings';

  // Storage keys
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyDefaultCurrency = 'default_currency';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLastSyncAt = 'last_sync_at';

  // Notification IDs
  static const int notifBudgetAlert = 1001;
  static const int notifMonthlySummary = 1002;

  // Background task names
  static const String taskSyncExpenses = 'sync_expenses';
  static const String taskMonthlyReport = 'monthly_report';

  // Pagination
  static const int pageSize = 30;

  // Default currency
  static const String defaultCurrency = 'USD';
}

import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<void> showBudgetAlert({
    required String categoryName,
    required double spent,
    required double budget,
  }) async {
    final String percent = ((spent / budget) * 100).toStringAsFixed(0);
    await _plugin.show(
      AppConstants.notifBudgetAlert,
      'Budget Alert: $categoryName',
      'You have used $percent% of your $categoryName budget.',
      _details('budget_alerts', 'Budget Alerts'),
    );
  }

  Future<void> scheduleMonthlySummary() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime firstOfNextMonth = tz.TZDateTime(
      tz.local,
      now.month == 12 ? now.year + 1 : now.year,
      now.month == 12 ? 1 : now.month + 1,
      9,
    );

    await _plugin.zonedSchedule(
      AppConstants.notifMonthlySummary,
      'Monthly Summary Ready',
      'Your expense summary for last month is ready. Tap to view.',
      firstOfNextMonth,
      _details('monthly_summary', 'Monthly Summary'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  NotificationDetails _details(String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
}

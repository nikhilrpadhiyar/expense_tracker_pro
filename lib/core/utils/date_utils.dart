import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  static String formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static String formatShort(DateTime date) => DateFormat('dd MMM').format(date);

  static String formatDayOfWeek(DateTime date) =>
      DateFormat('EEE').format(date);

  static DateTime get startOfMonth {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  static DateTime get endOfMonth {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  static DateTime startOfMonthFor(int year, int month) => DateTime(year, month);

  static DateTime endOfMonthFor(int year, int month) =>
      DateTime(year, month + 1, 0, 23, 59, 59);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static List<DateTime> last12Months() {
    final DateTime now = DateTime.now();
    return List<DateTime>.generate(
      12,
      (int i) => DateTime(now.year, now.month - i),
    ).reversed.toList();
  }
}

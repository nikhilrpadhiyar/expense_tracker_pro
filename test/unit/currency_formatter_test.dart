import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_pro/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter.format', () {
    test('formats USD correctly', () {
      expect(CurrencyFormatter.format(1234.5), '\$1,234.50');
    });

    test('formats zero', () {
      expect(CurrencyFormatter.format(0), '\$0.00');
    });
  });

  group('CurrencyFormatter.formatCompact', () {
    test('returns compact K for thousands', () {
      expect(CurrencyFormatter.formatCompact(5000), '\$5.0K');
    });

    test('returns compact M for millions', () {
      expect(CurrencyFormatter.formatCompact(2000000), '\$2.0M');
    });

    test('returns full format for small amounts', () {
      expect(CurrencyFormatter.formatCompact(99), '\$99.00');
    });
  });
}

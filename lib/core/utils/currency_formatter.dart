import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, {String currency = 'USD'}) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: _symbol(currency),
      decimalDigits: 2,
    ).format(amount);
  }

  static String formatCompact(double amount, {String currency = 'USD'}) {
    final symbol = _symbol(currency);
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount, currency: currency);
  }

  static String _symbol(String currency) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'INR': '₹',
      'JPY': '¥',
    };
    return symbols[currency] ?? currency;
  }
}

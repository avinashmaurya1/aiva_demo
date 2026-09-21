import 'package:intl/intl.dart';

/// Formatter for prices and currencies (INR ₹, USD, etc.)
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Formats amount into Indian Rupee format, e.g. ₹5,499
  static String formatInr(num amount) {
    return _inrFormatter.format(amount);
  }

  /// Formats amount with given currency code (default: INR)
  static String format(num amount, {String currency = 'INR'}) {
    if (currency.toUpperCase() == 'INR') {
      return formatInr(amount);
    }
    final formatter = NumberFormat.currency(
      name: currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

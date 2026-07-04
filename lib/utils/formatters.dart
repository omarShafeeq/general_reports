import 'package:intl/intl.dart';

abstract final class Formatters {
  static final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  static final compactCurrency = NumberFormat.compactCurrency(symbol: '\$');
  static final compactNumber = NumberFormat.compact();
  static final percentFormat = NumberFormat.percentPattern();
  static final decimalFormat = NumberFormat('#,##0.00');
  static final integerFormat = NumberFormat('#,##0');

  static final shortDate = DateFormat('MMM dd');
  static final mediumDate = DateFormat('MMM dd, yyyy');
  static final monthYear = DateFormat('MMM yyyy');

  static String formatValue(num value, {bool compact = true, bool isCurrency = false}) {
    if (isCurrency) {
      return compact ? compactCurrency.format(value) : currencyFormat.format(value);
    }
    return compact ? compactNumber.format(value) : integerFormat.format(value);
  }

  static String formatChange(double change) {
    final prefix = change >= 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(1)}%';
  }
}

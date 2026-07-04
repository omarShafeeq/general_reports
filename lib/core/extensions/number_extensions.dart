import 'package:intl/intl.dart';

extension NumberFormatting on num {
  String get compact => NumberFormat.compact().format(this);

  String get currency => NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);

  String get currencyCompact => NumberFormat.compactCurrency(symbol: '\$').format(this);

  String get percentage => '${toStringAsFixed(1)}%';

  String get withCommas => NumberFormat('#,##0').format(this);

  String get withDecimals => NumberFormat('#,##0.00').format(this);
}

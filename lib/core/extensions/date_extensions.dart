import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get shortDate => DateFormat('MMM dd').format(this);
  String get mediumDate => DateFormat('MMM dd, yyyy').format(this);
  String get longDate => DateFormat('MMMM dd, yyyy').format(this);
  String get monthYear => DateFormat('MMM yyyy').format(this);
  String get yearOnly => DateFormat('yyyy').format(this);
  String get timeOnly => DateFormat('HH:mm').format(this);
  String get dateTime => DateFormat('MMM dd, yyyy HH:mm').format(this);
  String get dayOfWeek => DateFormat('EEEE').format(this);
  String get shortDayOfWeek => DateFormat('EEE').format(this);
}

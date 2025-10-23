import 'package:intl/intl.dart';

class Formatters {
  static String currency(num value) =>
      NumberFormat.currency(symbol: 'ج.م').format(value);
  static String date(DateTime date) => DateFormat('yyyy/MM/dd').format(date);
}

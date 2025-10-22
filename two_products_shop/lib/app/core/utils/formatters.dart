import 'package:intl/intl.dart';

class Formatters {
  static String money(double value, {String currency = 'ج.م'}) {
    final f = NumberFormat('#,##0.00', 'ar_EG');
    return '${f.format(value)} $currency';
  }

  static String date(DateTime d) {
    return DateFormat('dd/MM/yyyy – hh:mm a', 'ar').format(d);
  }

  static String short(String t, [int max = 40]) {
    if (t.length <= max) return t;
    return '${t.substring(0, max)}...';
  }
}

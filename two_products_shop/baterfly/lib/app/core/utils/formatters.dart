class Fmt {
  static String price(num v) {
    if (v % 1 == 0) {
      return v.toInt().toString();
    } else {
      return v.toStringAsFixed(2);
    }
  }

  static String numFixed(num v, [int digits = 1]) => v.toStringAsFixed(digits);
}

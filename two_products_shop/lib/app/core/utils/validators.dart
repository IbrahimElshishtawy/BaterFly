class Validators {
  static String? requiredText(String? v, {int min = 1}) {
    if (v == null || v.trim().length < min) return 'برجاء إدخال قيمة صحيحة';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.isEmpty) return 'رقم الهاتف مطلوب';
    final ok = RegExp(r'^\+?[0-9]{8,15}$').hasMatch(v);
    return ok ? null : 'رقم هاتف غير صالح';
  }

  static String? fullName(String? v) => requiredText(v, min: 10);

  static String? address(String? v) => requiredText(v, min: 15);

  static String? comment(String? v) => requiredText(v, min: 20);

  static String? rating(int? r) {
    if (r == null || r < 1 || r > 5) return 'التقييم من 1 إلى 5';
    return null;
  }
}

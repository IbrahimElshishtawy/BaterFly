class Validators {
  static String? requiredField(String? v) =>
      (v == null || v.isEmpty) ? 'الحقل مطلوب' : null;

  static String? phone(String? v) {
    if (v == null || v.isEmpty) return 'رقم الهاتف مطلوب';
    final pattern = RegExp(r'^\+?[0-9]{8,15}$');
    if (!pattern.hasMatch(v)) return 'رقم هاتف غير صالح';
    return null;
  }
}

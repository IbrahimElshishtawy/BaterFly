class Validators {
  static bool phone(String value) {
    final pattern = RegExp(r'^\+?[0-9]{8,15}$');
    return pattern.hasMatch(value.trim());
  }

  static bool email(String value) {
    final pattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return pattern.hasMatch(value.trim());
  }

  static bool notEmpty(String value) => value.trim().isNotEmpty;
}

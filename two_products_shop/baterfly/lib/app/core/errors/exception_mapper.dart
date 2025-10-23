class ExceptionMapper {
  static String map(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network')) return 'تحقق من اتصال الإنترنت.';
    if (msg.contains('timeout')) return 'انتهت مهلة الاتصال.';
    if (msg.contains('auth')) return 'خطأ في تسجيل الدخول.';
    return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
  }
}

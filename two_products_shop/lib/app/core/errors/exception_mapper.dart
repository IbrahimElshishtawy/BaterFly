import 'failure.dart';

class ExceptionMapper {
  static Failure map(dynamic e) {
    final msg = e.toString();
    if (msg.contains('rate_limited')) {
      return Failure('محاولة كثيرة خلال وقت قصير', code: 'rate_limited');
    }
    if (msg.contains('invalid_product')) {
      return Failure('منتج غير متاح', code: 'invalid_product');
    }
    if (msg.contains('already_reviewed')) {
      return Failure(
        'تم إرسال تقييم سابق لهذا الطلب',
        code: 'already_reviewed',
      );
    }
    return Failure('حدث خطأ غير متوقع');
  }
}

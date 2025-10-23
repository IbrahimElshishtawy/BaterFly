import '../../../core/utils/validators.dart';
import '../../../data/datasources/remote/orders_remote.dart';

class CheckoutController {
  final OrdersRemote _remote;
  CheckoutController({OrdersRemote? remote})
    : _remote = remote ?? OrdersRemote();

  Future<String?> submit({
    required int productId,
    required String fullName,
    required String phone,
    required String address,
    int quantity = 1,
    String? notes,
  }) async {
    if (fullName.trim().length < 10) return 'الاسم لازم يكون 10 أحرف على الأقل';
    if (!Validators.phone(phone)) return 'رقم الهاتف غير صالح';
    if (address.trim().length < 15) return 'العنوان قصير';
    final res = await _remote.createOrder(
      productId: productId,
      quantity: quantity,
      fullName: fullName.trim(),
      phone1: phone.trim(),
      addressText: address.trim(),
      notes: notes,
    );
    return res['order_no']?.toString();
  }
}

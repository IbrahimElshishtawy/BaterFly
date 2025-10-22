import 'package:flutter/foundation.dart';
import '../../../data/datasources/remote/orders_remote.dart';

class CheckoutController with ChangeNotifier {
  final OrdersRemote _remote;
  CheckoutController(this._remote);

  bool loading = false;

  Future<void> submit({
    required int productId,
    required int quantity,
    required String fullName,
    required String phone1,
    String? phone2,
    String? city,
    String? area,
    required String addressText,
    String? notes,
    String? sessionId,
  }) async {
    loading = true;
    notifyListeners();
    try {
      await _remote.createOrder(
        productId: productId,
        quantity: quantity,
        fullName: fullName,
        phone1: phone1,
        phone2: phone2,
        city: city,
        area: area,
        addressText: addressText,
        notes: notes,
        sessionId: sessionId,
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

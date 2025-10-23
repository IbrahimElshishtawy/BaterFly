// ignore_for_file: unnecessary_cast

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class OrdersRemote {
  final SupabaseClient _sb = Supa.client;
  static const _table = 'orders';

  Future<Map<String, dynamic>> createOrder({
    required int productId,
    required int quantity,
    required String fullName,
    required String phone1,
    String? phone2,
    String? city,
    String? area,
    required String addressText,
    String? notes,
    String paymentMethod = 'cod',
  }) async {
    final orderNo = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final payload = {
      'order_no': orderNo,
      'product_id': productId,
      'quantity': quantity,
      'full_name': fullName,
      'phone1': phone1,
      'phone2': phone2,
      'city': city,
      'area': area,
      'address_text': addressText,
      'notes': notes,
      'payment_method': paymentMethod,
    };
    final inserted = await _sb.from(_table).insert(payload).select().single();
    return inserted as Map<String, dynamic>;
  }
}

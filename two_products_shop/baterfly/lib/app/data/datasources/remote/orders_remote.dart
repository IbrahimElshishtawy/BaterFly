import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class OrdersRemote {
  final SupabaseClient _sb = Supa.client;
  final String _table = 'orders';

  Future<Map<String, dynamic>> createOrder({
    required int productId,
    required int quantity,
    required String fullName,
    required String phone1,
    String? phone2,
    required String addressText,
    String? notes,
  }) async {
    final orderNo = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final data = {
      'order_no': orderNo,
      'product_id': productId,
      'quantity': quantity,
      'full_name': fullName,
      'phone1': phone1,
      'phone2': phone2,
      'address_text': addressText,
      'notes': notes,
      'status': 'new',
      'payment_method': 'cod',
    };
    final inserted = await _sb
        .from(_table)
        .insert(data)
        .select()
        .limit(1)
        .single();
    return inserted;
  }
}

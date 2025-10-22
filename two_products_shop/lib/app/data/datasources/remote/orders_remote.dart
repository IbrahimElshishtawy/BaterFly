import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';

class OrdersRemote {
  final SupabaseClient _db = Supa.client;

  Future<void> createOrder({
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
    final rand = Random().nextInt(9000) + 1000;
    final today = DateTime.now();
    final ymd =
        "${today.year.toString().padLeft(4, '0')}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    final orderNo = "ORD-$ymd-$rand";

    await _db.from(AppConstants.tblOrders).insert({
      'order_no': orderNo,
      'product_id': productId,
      'quantity': quantity,
      'full_name': fullName,
      'phone1': phone1,
      'phone2': phone2,
      'city': city,
      'area': area,
      'address_text': addressText,
      'address_norm': addressText.trim().replaceAll(RegExp(r'\s+'), ' '),
      'notes': notes,
      'status': 'new',
      'payment_method': 'cod',
      'session_id': sessionId,
    });
  }
}

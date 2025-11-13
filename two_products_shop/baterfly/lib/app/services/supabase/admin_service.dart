// services/admin_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final _db = Supabase.instance.client;

  // ================= ORDERS =================
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final res = await _db
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<Map<String, dynamic>> fetchOrderById(int id) async {
    final res = await _db.from('orders').select().eq('id', id).single();
    return Map<String, dynamic>.from(res);
  }

  Future<void> updateOrderStatus(int id, String status) async {
    await _db.from('orders').update({'status': status}).eq('id', id);
  }

  // ================= REVIEWS =================

  bool _normalizeIsVerified(dynamic v) {
    return v == true || v == 1 || v == 'true';
  }

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final res = await _db
        .from('product_reviews')
        .select() // مفيش join هنا
        .order('created_at', ascending: false);

    final list = List<Map<String, dynamic>>.from(
      (res as List).map((r) {
        final map = Map<String, dynamic>.from(r as Map);

        // توحيد is_verified كبوليان
        map['is_verified'] = _normalizeIsVerified(map['is_verified']);

        // علشان الـ UI ما يتكسرش، نزود مفاتيح وهمية لو مش موجودة
        map.putIfAbsent('product_name', () => null);
        map.putIfAbsent('order_no', () => null);
        map.putIfAbsent('customer_name', () => null);

        return map;
      }),
    );

    // debug اختياري
    // print('REVIEWS FROM DB: $list');

    return list;
  }

  Future<void> verifyReview(int id, bool isVerified) async {
    final updatePayload = {
      'is_verified': isVerified, // لو العمود Boolean
      // لو العمود INT:
      // 'is_verified': isVerified ? 1 : 0,
    };

    await _db.from('product_reviews').update(updatePayload).eq('id', id);
  }
}

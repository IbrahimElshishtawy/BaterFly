// services/admin_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final _db = Supabase.instance.client;

  // ================= ORDERS =================

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final res = await _db
        .from('orders')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<Map<String, dynamic>> fetchOrderById(int id) async {
    final res = await _db.from('orders').select().eq('id', id).single();

    return Map<String, dynamic>.from(res as Map);
  }

  Future<void> updateOrderStatus(int id, String status) async {
    await _db.from('orders').update({'status': status}).eq('id', id);
  }

  // ================= REVIEWS =================

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final res = await _db
        .from('product_reviews')
        .select()
        .order('created_at', ascending: false);

    final list = List<Map<String, dynamic>>.from(res as List);

    // Debug عشان تشوف الداتا من Supabase
    if (kDebugMode) {
      print('REVIEWS FROM DB RAW: $list');
    }

    return list;
  }

  Future<void> verifyReview(int id, bool isVerified) async {
    // بافتراض إن is_verified نوعه boolean في الجدول
    final payload = {'is_verified': isVerified};

    final res = await _db
        .from('product_reviews')
        .update(payload)
        .eq('id', id)
        .select(); // نرجع الصف بعد التحديث (للدebug)

    if (kDebugMode) {
      print('UPDATED ROW: $res');
    }
  }
}

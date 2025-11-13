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
  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final res = await _db
        .from('product_reviews')
        .select(
          'id, rating, comment, is_verified, created_at, order_no, product_name',
        )
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> verifyReview(int id, bool isVerified) async {
    await _db
        .from('product_reviews')
        .update({'is_verified': isVerified})
        .eq('id', id);
  }
}

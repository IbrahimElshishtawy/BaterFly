// services/admin_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final _db = Supabase.instance.client;

  // Orders
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

  // Products (basic)
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final res = await _db
        .from('products')
        .select()
        .order('id', ascending: true);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<int> createProduct(Map<String, dynamic> data) async {
    final resp = await _db.from('products').insert(data).select('id').single();
    return resp['id'];
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    await _db.from('products').update(data).eq('id', id);
  }

  Future<void> deleteProduct(int id) async {
    await _db.from('products').delete().eq('id', id);
  }

  // Reviews
  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final res = await _db
        .from('product_reviews')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> verifyReview(int id, bool isVerified) async {
    await _db
        .from('product_reviews')
        .update({'is_verified': isVerified})
        .eq('id', id);
  }

  // Settings
  Future<Map<String, dynamic>?> fetchSettings() async {
    final res = await _db.from('settings').select().limit(1).single();
    return Map<String, dynamic>.from(res);
  }

  Future<void> updateSettings(Map<String, dynamic> data) async {
    // if settings table has single row you can upsert:
    await _db.from('settings').upsert(data);
  }
}

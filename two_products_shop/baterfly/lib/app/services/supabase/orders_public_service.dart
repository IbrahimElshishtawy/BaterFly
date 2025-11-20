// lib/app/services/supabase/orders_public_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersPublicService {
  final _client = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> findOrdersByFullName(
    String fullName,
  ) async {
    final q = fullName.trim();
    if (q.isEmpty) return [];

    final data = await _client
        .from('orders')
        .select('id, order_no, full_name, status, created_at, city, area')
        .ilike('full_name', '%$q%')
        .order('created_at', ascending: false);

    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getOrderById(int id) async {
    final data = await _client
        .from('orders')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;
    return data;
  }
}

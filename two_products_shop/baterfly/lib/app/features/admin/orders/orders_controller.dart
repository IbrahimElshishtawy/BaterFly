import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class OrdersController {
  final SupabaseClient _sb = Supa.client;

  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await _sb
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> updateStatus(int id, String status) async {
    await _sb.from('orders').update({'status': status}).eq('id', id);
  }

  Future<void> deleteOrder(int id) async {
    await _sb.from('orders').delete().eq('id', id);
  }
}

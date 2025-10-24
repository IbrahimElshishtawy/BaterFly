import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminReviewsController {
  final SupabaseClient _sb = Supa.client;
  final String _table = 'product_reviews';

  Future<List<Map<String, dynamic>>> listAll({String? status}) async {
    var q = _sb.from(_table).select().order('created_at', ascending: false);
    if (status != null) {
      q = q.eq('status', status);
    }
    final res = await q;
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> approve(int id) async {
    await _sb.from(_table).update({'status': 'approved'}).eq('id', id);
  }

  Future<void> reject(int id) async {
    await _sb.from(_table).update({'status': 'rejected'}).eq('id', id);
  }

  Future<void> delete(int id) async {
    await _sb.from(_table).delete().eq('id', id);
  }

  Future<void> setVerified(int id, bool v) async {
    await _sb.from(_table).update({'is_verified': v}).eq('id', id);
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminReviewsController {
  AdminReviewsController();

  static const _table = 'product_reviews';
  final SupabaseClient _sb = Supa.client;

  Future<List<Map<String, dynamic>>> list({String? status}) async {
    final sel = _sb.from(_table).select();
    final res = status == null
        ? await sel.order('created_at', ascending: false)
        : await sel
              .eq('status', status)
              .order('created_at', ascending: false); // eq before order
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> updateStatus({
    required int id,
    required String status,
    bool? isVerified,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (isVerified != null) data['is_verified'] = isVerified;
    await _sb.from(_table).update(data).eq('id', id);
  }

  Future<void> approve(int id, {bool verify = true}) =>
      updateStatus(id: id, status: 'approved', isVerified: verify);

  Future<void> reject(int id) => updateStatus(id: id, status: 'rejected');

  Future<void> delete(int id) async {
    await _sb.from(_table).delete().eq('id', id);
  }
}

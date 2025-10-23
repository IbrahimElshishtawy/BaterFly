import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class ReviewsRemote {
  final SupabaseClient _sb = Supa.client;
  static const _table = 'product_reviews';

  Future<List<Map<String, dynamic>>> listApproved(int productId) async {
    final res = await _sb
        .from(_table)
        .select()
        .eq('product_id', productId)
        .eq('status', 'approved')
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> submit({
    required int productId,
    required String fullName,
    required int rating,
    required String comment,
  }) async {
    await _sb.from(_table).insert({
      'product_id': productId,
      'full_name': fullName,
      'rating': rating,
      'comment': comment,
      'is_verified': false,
    });
  }
}

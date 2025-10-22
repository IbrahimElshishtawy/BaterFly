import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';

class ReviewsRemote {
  final SupabaseClient _db = Supa.client;

  Future<List<Map<String, dynamic>>> fetchApproved(int productId) async {
    final res = await _db
        .from(AppConstants.tblReviews)
        .select()
        .eq('product_id', productId)
        .eq('status', 'approved')
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> addAnonymous({
    required int productId,
    required int rating,
    required String comment,
    String? fullName,
  }) async {
    await _db.from(AppConstants.tblReviews).insert({
      'product_id': productId,
      'rating': rating,
      'comment': comment,
      if (fullName != null && fullName.trim().isNotEmpty)
        'full_name': fullName.trim(),
    });
  }
}

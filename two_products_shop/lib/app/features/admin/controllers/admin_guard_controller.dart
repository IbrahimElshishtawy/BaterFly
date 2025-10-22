import 'package:supabase_flutter/supabase_flutter.dart';

class AdminGuardController {
  final SupabaseClient _db = Supabase.instance.client;

  Future<bool> isAdmin() async {
    final user = _db.auth.currentUser;
    if (user == null) return false;
    final row = await _db
        .from('admins')
        .select('user_id')
        .eq('user_id', user.id)
        .maybeSingle();
    return row != null;
  }
}

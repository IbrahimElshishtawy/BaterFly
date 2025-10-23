import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminGuardController {
  final SupabaseClient _sb = Supa.client;

  Future<bool> isAdmin() async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) return false;
    final res = await _sb
        .from('admins')
        .select('user_id')
        .eq('user_id', uid)
        .maybeSingle();
    return res != null;
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminGuardController {
  final SupabaseClient _sb = Supa.client;

  Future<bool> isAdmin() async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) return false;
    final row = await _sb
        .from('admins')
        .select('user_id')
        .eq('user_id', uid)
        .maybeSingle();

    return row != null;
  }

  // بديل بدون eq:
  Future<bool> isAdminNoEq() async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) return false;

    final row = await _sb
        .from('admins')
        .select('user_id')
        .filter('user_id', 'eq', uid)
        .maybeSingle();

    return row != null;
  }
}

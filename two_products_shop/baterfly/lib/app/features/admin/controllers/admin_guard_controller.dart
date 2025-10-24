import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase/supabase_service.dart';

class AdminGuardController {
  final SupabaseClient _sb = Supa.client;

  Future<String?> login(String email, String password) async {
    try {
      final res = await _sb.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (res.session == null) {
        return 'فشل تسجيل الدخول';
      }
      return null; // نجاح
    } catch (e) {
      return e.toString();
    }
  }

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

  /// تسجيل الخروج.
  Future<void> signOut() => _sb.auth.signOut();
}

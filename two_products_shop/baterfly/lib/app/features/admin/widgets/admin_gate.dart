import 'package:baterfly/app/services/supabase/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminGate extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  const AdminGate({super.key, required this.child, this.fallback});

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  late final Future<bool> _allowed;
  final SupabaseClient _sb = Supa.client;

  Future<bool> _check() async {
    final uid = _sb.auth.currentUser?.id;
    if (uid == null) return false;

    final row = await _sb
        .from('admins')
        .select('user_id')
        .eq('user_id', uid) // أو filter('user_id','eq',uid)
        .maybeSingle();

    return row != null;
  }

  @override
  void initState() {
    super.initState();
    _allowed = _check();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _allowed,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final ok = snap.data ?? false;
        if (ok) return widget.child;

        return widget.fallback ??
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, size: 48),
                  SizedBox(height: 12),
                  Text('هذه الصفحة للمشرفين فقط'),
                ],
              ),
            );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../admin/auth/admin_login_page.dart';

class AdminGate extends StatefulWidget {
  final Widget child;
  const AdminGate({super.key, required this.child});

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  bool _checking = true;
  bool _allowed = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final s = Supabase.instance.client;
    final user = s.auth.currentUser;
    if (user == null) {
      final ok = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const AdminLoginPage()),
      );
      if (ok != true) {
        return setState(() {
          _checking = false;
          _allowed = false;
        });
      }
    }
    final u = s.auth.currentUser;
    if (u == null) {
      return setState(() {
        _checking = false;
        _allowed = false;
      });
    }

    final row = await s
        .from('admins')
        .select('user_id')
        .eq('user_id', u.id)
        .maybeSingle();
    setState(() {
      _allowed = row != null;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_allowed) {
      return const Scaffold(body: Center(child: Text('صلاحية الأدمن مطلوبة')));
    }
    return widget.child;
  }
}

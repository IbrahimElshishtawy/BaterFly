// widgets/admin_gate.dart
import 'package:flutter/material.dart';

class AdminGate extends StatelessWidget {
  final Widget child;
  final bool allowed;

  const AdminGate({super.key, required this.child, this.allowed = false});

  @override
  Widget build(BuildContext context) {
    if (!allowed) {
      return const Scaffold(
        body: Center(child: Text('غير مسموح بالدخول — سجل دخول الأدمن')),
      );
    }
    return child;
  }
}

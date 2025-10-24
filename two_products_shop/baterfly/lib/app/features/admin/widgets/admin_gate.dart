import 'package:flutter/material.dart';
import '../controllers/admin_guard_controller.dart';
import '../auth/admin_login_page.dart';

class AdminGate extends StatelessWidget {
  final Widget child;
  const AdminGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AdminGuardController().isAdmin(),
      builder: (context, s) {
        if (s.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.data == true) return child;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 12),
              const Text('هذه الصفحة للأدمن فقط'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminLoginPage()),
                  );
                },
                child: const Text('تسجيل دخول الأدمن'),
              ),
            ],
          ),
        );
      },
    );
  }
}

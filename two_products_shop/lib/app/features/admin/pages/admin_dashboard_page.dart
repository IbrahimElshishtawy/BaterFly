import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ListTile(leading: Icon(Icons.shopping_cart), title: Text('الطلبات')),
          Divider(),
          ListTile(leading: Icon(Icons.reviews), title: Text('التقييمات')),
          Divider(),
          ListTile(leading: Icon(Icons.settings), title: Text('الإعدادات')),
        ],
      ),
    );
  }
}

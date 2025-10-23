import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _sb = Supa.client;
  late Future<List<Map<String, dynamic>>> f;

  @override
  void initState() {
    super.initState();
    f = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final res = await _sb
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الطلبات')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: f,
        builder: (c, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = s.data!;
          if (orders.isEmpty) return const Center(child: Text('لا توجد طلبات'));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final o = orders[i];
              return ListTile(
                title: Text(o['full_name']),
                subtitle: Text(o['phone1']),
                trailing: Text(o['status']),
              );
            },
          );
        },
      ),
    );
  }
}

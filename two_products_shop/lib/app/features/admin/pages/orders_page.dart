import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/formatters.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await Supa.client
        .from(AppConstants.tblOrders)
        .select()
        .order('created_at', ascending: false);
    setState(() {
      _orders = (res as List).cast<Map<String, dynamic>>();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_orders.isEmpty) {
      return const Center(child: Text('لا توجد طلبات حالياً'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات')),
      body: ListView.separated(
        itemCount: _orders.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (_, i) {
          final o = _orders[i];
          return ListTile(
            title: Text('طلب ${o['order_no'] ?? ''}'),
            subtitle: Text('${o['full_name']} - ${o['phone1']}'),
            trailing: Text(Formatters.date(DateTime.parse(o['created_at']))),
          );
        },
      ),
    );
  }
}

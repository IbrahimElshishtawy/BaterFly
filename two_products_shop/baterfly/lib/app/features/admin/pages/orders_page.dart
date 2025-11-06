// pages/orders_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../controllers/orders_controller.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersController()..loadOrders(),
      child: Consumer<OrdersController>(
        builder: (context, ctrl, _) {
          if (ctrl.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final o = ctrl.orders[i];
              return Card(
                child: ListTile(
                  title: Text(o['full_name'] ?? 'لا يوجد اسم'),
                  subtitle: Text(
                    'Order #${o['order_no'] ?? o['id']}\n${o['address_text'] ?? ''}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      await ctrl.changeStatus(o['id'] as int, v);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'pending',
                        child: Text('قيد الانتظار'),
                      ),
                      PopupMenuItem(
                        value: 'processing',
                        child: Text('قيد التنفيذ'),
                      ),
                      PopupMenuItem(value: 'shipped', child: Text('تم الشحن')),
                      PopupMenuItem(value: 'done', child: Text('مكتمل')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

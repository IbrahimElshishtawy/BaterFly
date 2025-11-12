// pages/orders_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../controllers/orders_controller.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const Map<String, String> _statusLabels = {
    'pending': 'قيد الانتظار',
    'processing': 'قيد التنفيذ',
    'shipped': 'تم الشحن',
    'done': 'مكتمل',
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersController()..loadOrders(),
      child: Consumer<OrdersController>(
        builder: (context, ctrl, _) {
          if (ctrl.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ استخدم الطلبات بعد الفلتر
          final orders = ctrl.filteredOrders;
          // ✅ خُد الإحصائيات من الكنترولر
          final counts = ctrl.statusCounts;

          return Column(
            children: [
              // 🔹 كارت الإحصائيات
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إجمالي الطلبات: ${ctrl.totalOrders}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('قيد الانتظار: ${counts['pending']}'),
                            Text('قيد التنفيذ: ${counts['processing']}'),
                            Text('تم الشحن: ${counts['shipped']}'),
                            Text('مكتمل: ${counts['done']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔹 فلتر الحالات (كل – قيد الانتظار – ... إلخ)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('الكل'),
                      selected: ctrl.statusFilter == null,
                      onSelected: (_) => ctrl.setFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ..._statusLabels.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ChoiceChip(
                          label: Text(e.value),
                          selected: ctrl.statusFilter == e.key,
                          onSelected: (_) => ctrl.setFilter(e.key),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 قائمة الطلبات
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final o = orders[i];
                    final status = (o['status'] ?? '').toString();

                    return Card(
                      child: ListTile(
                        title: Text(o['full_name'] ?? 'لا يوجد اسم'),
                        subtitle: Text(
                          'Order #${o['order_no'] ?? o['id']}\n${o['address_text'] ?? ''}',
                        ),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الحالة:',
                              style: TextStyle(fontSize: 11),
                            ),
                            Text(
                              _statusLabels[status] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                            PopupMenuItem(
                              value: 'shipped',
                              child: Text('تم الشحن'),
                            ),
                            PopupMenuItem(value: 'done', child: Text('مكتمل')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// pages/widgets/orders_list.dart
import 'package:flutter/material.dart';
import 'order_status_utils.dart';

class OrdersList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final bool isWide;
  final bool isTablet;
  final Future<void> Function(int id, String status) onChangeStatus;

  const OrdersList({
    super.key,
    required this.orders,
    required this.isWide,
    required this.isTablet,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد طلبات حتى الآن',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(isTablet || isWide ? 16 : 8),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final o = orders[i];
        final status = (o['status'] ?? '').toString();
        final statusClr = statusColor(status);

        // الكمية
        final num quantity = num.tryParse(o['quantity'].toString()) ?? 1;

        // الوحدة
        final String unit = (o['quantity_unit'] ?? 'unit').toString();

        String unitLabel;
        switch (unit) {
          case 'gram':
            unitLabel = 'جرام';
            break;
          case 'liter':
            unitLabel = 'لتر';
            break;
          default:
            unitLabel = 'وحدة';
        }

        return Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: CircleAvatar(
              radius: isWide ? 20 : 18,
              backgroundColor: Colors.deepPurple.withOpacity(0.08),
              child: const Icon(Icons.person_outline, color: Colors.deepPurple),
            ),
            title: Text(
              o['full_name'] ?? 'لا يوجد اسم',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Order #${o['order_no'] ?? o['id']}',
                  style: const TextStyle(fontSize: 12),
                ),

                // 🟢 الكمية + الوحدة
                Text(
                  'الكمية المطلوبة: $quantity $unitLabel',
                  style: const TextStyle(fontSize: 12),
                ),

                // العنوان
                if ((o['address_text'] ?? '').toString().isNotEmpty)
                  Text(o['address_text'], style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusClr.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    kStatusLabels[status] ?? '-',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusClr,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                PopupMenuButton<String>(
                  tooltip: 'تغيير الحالة',
                  onSelected: (v) async {
                    await onChangeStatus(o['id'] as int, v);
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
                  child: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

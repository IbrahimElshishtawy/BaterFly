// pages/widgets/orders_list.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'order_status_utils.dart';

class OrdersList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final bool isWide;
  final bool isTablet;
  final Future<void> Function(int id, String status) onChangeStatus;

  final Future<void> Function(int id) onDeleteOrder;

  const OrdersList({
    super.key,
    required this.orders,
    required this.isWide,
    required this.isTablet,
    required this.onChangeStatus,
    required this.onDeleteOrder,
  });

  // ==========================
  // فتح واتساب
  // ==========================
  Future<void> _openWhatsApp(String rawPhone) async {
    // تنظيف الرقم
    final phone = rawPhone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.isEmpty) return;

    final uri = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('لا يمكن فتح واتساب للرقم: $phone');
    }
  }

  // ==========================
  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
          'هل أنت متأكد من حذف هذا الطلب؟ لا يمكن التراجع عن هذه العملية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

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
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, i) {
        final o = orders[i];
        final status = (o['status'] ?? '').toString();
        final statusClr = statusColor(status);

        // رقم الهاتف
        final String phone = (o['phone1'] ?? o['phone2']).toString();

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
              vertical: 12,
            ),
            leading: CircleAvatar(
              radius: isWide ? 20 : 18,
              backgroundColor: const Color.fromARGB(
                255,
                58,
                85,
                183,
              ).withOpacity(0.08),
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

                // ==========================
                // الهاتف (قابل للضغط)
                // ==========================
                if (phone.isNotEmpty)
                  InkWell(
                    onTap: () => _openWhatsApp(phone),
                    child: Text(
                      'الهاتف: $phone',
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.green,
                      ),
                    ),
                  )
                else
                  const Text('الهاتف: -', style: TextStyle(fontSize: 12)),

                Text(
                  'الكمية المطلوبة: $quantity $unitLabel',
                  style: const TextStyle(fontSize: 12),
                ),

                Text(
                  'city: ${o['city'] ?? '-'}',
                  style: const TextStyle(fontSize: 12),
                ),

                Text(
                  'area: ${o['area'] ?? '-'}',
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
                const SizedBox(height: 4),

                // ==========================
                // منيو: تغيير حالة + حذف
                // ==========================
                PopupMenuButton<String>(
                  tooltip: 'خيارات الطلب',
                  onSelected: (v) async {
                    if (v == 'delete') {
                      final ok = await _confirmDelete(context);
                      if (ok) {
                        await onDeleteOrder(o['id'] as int);
                      }
                    } else {
                      await onChangeStatus(o['id'] as int, v);
                    }
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
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'حذف الطلب',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
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

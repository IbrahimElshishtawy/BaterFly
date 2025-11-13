// pages/orders_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../../controllers/orders_controller.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const Map<String, String> _statusLabels = {
    'pending': 'قيد الانتظار',
    'processing': 'قيد التنفيذ',
    'shipped': 'تم الشحن',
    'done': 'مكتمل',
  };

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersController()..loadOrders(),
      child: Consumer<OrdersController>(
        builder: (context, ctrl, _) {
          if (ctrl.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = ctrl.filteredOrders;
          final counts = ctrl.statusCounts;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900; // ويب واسع
              final isTablet = constraints.maxWidth > 600 && !isWide;

              return Container(
                color: Colors.grey[100],
                child: Center(
                  // علشان المحتوى ما يتمطّش على شاشات عريضة جدًا
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      children: [
                        // 🔹 رأس صغير أنيق مع زر تحديث
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'إدارة الطلبات',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'تحديث',
                                onPressed: () => ctrl.loadOrders(),
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        ),

                        // 🔹 كارت الإحصائيات (يتكيّف حسب العرض)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 14.0,
                              ),
                              child: isWide
                                  // شاشة واسعة: صف أفقي
                                  ? Row(
                                      children: [
                                        // إجمالي
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'إجمالي الطلبات',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${ctrl.totalOrders}',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // الحالات
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _statPill(
                                                label: 'قيد الانتظار',
                                                value: counts['pending'],
                                                color: _statusColor('pending'),
                                              ),
                                              _statPill(
                                                label: 'قيد التنفيذ',
                                                value: counts['processing'],
                                                color: _statusColor(
                                                  'processing',
                                                ),
                                              ),
                                              _statPill(
                                                label: 'تم الشحن',
                                                value: counts['shipped'],
                                                color: _statusColor('shipped'),
                                              ),
                                              _statPill(
                                                label: 'مكتمل',
                                                value: counts['done'],
                                                color: _statusColor('done'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  // موبايل / تابلت: كولمن فوق بعض
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'إجمالي الطلبات',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${ctrl.totalOrders}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 8,
                                          children: [
                                            _statPill(
                                              label: 'قيد الانتظار',
                                              value: counts['pending'],
                                              color: _statusColor('pending'),
                                            ),
                                            _statPill(
                                              label: 'قيد التنفيذ',
                                              value: counts['processing'],
                                              color: _statusColor('processing'),
                                            ),
                                            _statPill(
                                              label: 'تم الشحن',
                                              value: counts['shipped'],
                                              color: _statusColor('shipped'),
                                            ),
                                            _statPill(
                                              label: 'مكتمل',
                                              value: counts['done'],
                                              color: _statusColor('done'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

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
                                selectedColor: Colors.deepPurple.shade50,
                                labelStyle: TextStyle(
                                  color: ctrl.statusFilter == null
                                      ? Colors.deepPurple
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ..._statusLabels.entries.map((e) {
                                final selected = ctrl.statusFilter == e.key;
                                final color = _statusColor(e.key);
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ChoiceChip(
                                    label: Text(e.value),
                                    selected: selected,
                                    onSelected: (_) => ctrl.setFilter(e.key),
                                    selectedColor: color.withOpacity(0.12),
                                    labelStyle: TextStyle(
                                      color: selected ? color : Colors.black87,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 قائمة الطلبات
                        Expanded(
                          child: orders.isEmpty
                              ? const Center(
                                  child: Text(
                                    'لا توجد طلبات حتى الآن',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.all(
                                    isTablet || isWide ? 16 : 8,
                                  ),
                                  itemCount: orders.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, i) {
                                    final o = orders[i];
                                    final status = (o['status'] ?? '')
                                        .toString();
                                    final statusColor = _statusColor(status);

                                    return Card(
                                      elevation: 1.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                        leading: CircleAvatar(
                                          radius: isWide ? 20 : 18,
                                          backgroundColor: Colors.deepPurple
                                              .withOpacity(0.08),
                                          child: const Icon(
                                            Icons.person_outline,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        title: Text(
                                          o['full_name'] ?? 'لا يوجد اسم',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(
                                              'Order #${o['order_no'] ?? o['id']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            if ((o['address_text'] ?? '')
                                                .toString()
                                                .isNotEmpty)
                                              Text(
                                                o['address_text'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // شارة الحالة
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(
                                                  0.08,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                _statusLabels[status] ?? '-',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            // قائمة تغيير الحالة
                                            PopupMenuButton<String>(
                                              tooltip: 'تغيير الحالة',
                                              onSelected: (v) async {
                                                await ctrl.changeStatus(
                                                  o['id'] as int,
                                                  v,
                                                );
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
                                                PopupMenuItem(
                                                  value: 'done',
                                                  child: Text('مكتمل'),
                                                ),
                                              ],
                                              child: const Icon(
                                                Icons.more_vert,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statPill({
    required String label,
    required int? value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${value ?? 0}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

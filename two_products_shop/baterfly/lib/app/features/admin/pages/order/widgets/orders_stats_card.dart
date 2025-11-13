// pages/widgets/orders_stats_card.dart
import 'package:flutter/material.dart';
import 'order_status_utils.dart';

class OrdersStatsCard extends StatelessWidget {
  final int totalOrders;
  final Map<String, int> counts;
  final bool isWide;

  const OrdersStatsCard({
    super.key,
    required this.totalOrders,
    required this.counts,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          child: isWide
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _totalColumn()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statPill(
                            label: 'قيد الانتظار',
                            value: counts['pending'],
                            color: statusColor('pending'),
                          ),
                          _statPill(
                            label: 'قيد التنفيذ',
                            value: counts['processing'],
                            color: statusColor('processing'),
                          ),
                          _statPill(
                            label: 'تم الشحن',
                            value: counts['shipped'],
                            color: statusColor('shipped'),
                          ),
                          _statPill(
                            label: 'مكتمل',
                            value: counts['done'],
                            color: statusColor('done'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _totalColumn(),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _statPill(
                          label: 'قيد الانتظار',
                          value: counts['pending'],
                          color: statusColor('pending'),
                        ),
                        _statPill(
                          label: 'قيد التنفيذ',
                          value: counts['processing'],
                          color: statusColor('processing'),
                        ),
                        _statPill(
                          label: 'تم الشحن',
                          value: counts['shipped'],
                          color: statusColor('shipped'),
                        ),
                        _statPill(
                          label: 'مكتمل',
                          value: counts['done'],
                          color: statusColor('done'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _totalColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إجمالي الطلبات',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          '$totalOrders',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
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

// ignore_for_file: deprecated_member_use, file_names

import 'package:baterfly/app/features/Track/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';

import 'package:baterfly/app/features/admin/pages/order/widgets/order_status_utils.dart';

class TrackOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final double sidePadding;
  final bool isLast;
  final VoidCallback? onViewDetails;

  const TrackOrderCard({
    super.key,
    required this.order,
    required this.sidePadding,
    this.isLast = false,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final status = (order['status'] ?? '').toString();
    final statusClr = statusColor(status);

    final orderNo = order['order_no']?.toString() ?? order['id'].toString();
    final fullName = order['full_name']?.toString() ?? 'بدون اسم';
    final city = order['city']?.toString() ?? '-';
    final area = order['area']?.toString() ?? '-';

    return Padding(
      padding: EdgeInsets.fromLTRB(
        sidePadding,
        8,
        sidePadding,
        isLast ? 24 : 8,
      ),
      child: Card(
        color: Colors.black.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان + الاسم + بادج الحالة
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الطلب #$orderNo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fullName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusClr.withOpacity(0.12),
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
                ],
              ),

              const SizedBox(height: 12),

              // المكان
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.white.withOpacity(.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$city - $area',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              OrderStatusTimeline(currentStatus: status),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onViewDetails,
                  child: const Text(
                    'تفاصيل أكثر',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

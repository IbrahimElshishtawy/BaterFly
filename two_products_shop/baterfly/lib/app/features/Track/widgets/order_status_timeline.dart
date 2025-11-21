// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:baterfly/app/features/admin/pages/order/widgets/order_status_utils.dart';

class OrderStatusTimeline extends StatelessWidget {
  final String currentStatus;

  const OrderStatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    const steps = ['pending', 'processing', 'shipped', 'done'];

    final currentIndex = !steps.contains(currentStatus)
        ? 0
        : steps.indexOf(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مراحل معالجة الطلب:',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(steps.length, (i) {
            final step = steps[i];
            final reached = i <= currentIndex;
            final color = statusColor(step);
            final label = kStatusLabels[step] ?? step;

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: reached ? color : Colors.grey[700],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(.4),
                            width: 1,
                          ),
                        ),
                      ),
                      if (i < steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: i < currentIndex
                                ? color.withOpacity(0.8)
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: reached
                          ? Colors.white
                          : Colors.white.withOpacity(.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

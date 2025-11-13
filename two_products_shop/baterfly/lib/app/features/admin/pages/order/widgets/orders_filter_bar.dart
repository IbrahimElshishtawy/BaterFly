// pages/widgets/orders_filter_bar.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'order_status_utils.dart';

class OrdersFilterBar extends StatelessWidget {
  final String? currentStatus;
  final void Function(String?) onFilterChanged;

  const OrdersFilterBar({
    super.key,
    required this.currentStatus,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('الكل'),
            selected: currentStatus == null,
            onSelected: (_) => onFilterChanged(null),
            selectedColor: Colors.deepPurple.shade50,
            labelStyle: TextStyle(
              color: currentStatus == null ? Colors.deepPurple : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          ...kStatusLabels.entries.map((e) {
            final selected = currentStatus == e.key;
            final color = statusColor(e.key);
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ChoiceChip(
                label: Text(e.value),
                selected: selected,
                onSelected: (_) => onFilterChanged(e.key),
                selectedColor: color.withOpacity(0.12),
                labelStyle: TextStyle(color: selected ? color : Colors.black87),
              ),
            );
          }),
        ],
      ),
    );
  }
}

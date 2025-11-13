// pages/widgets/order_status_utils.dart
import 'package:flutter/material.dart';

const Map<String, String> kStatusLabels = {
  'pending': 'قيد الانتظار',
  'processing': 'قيد التنفيذ',
  'shipped': 'تم الشحن',
  'done': 'مكتمل',
};

Color statusColor(String status) {
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

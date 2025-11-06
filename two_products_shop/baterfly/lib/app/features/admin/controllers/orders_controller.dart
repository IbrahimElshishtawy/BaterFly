// controllers/orders_controller.dart
import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/material.dart';

class OrdersController extends ChangeNotifier {
  final AdminService _service = AdminService();
  List<Map<String, dynamic>> orders = [];
  bool loading = false;

  Future<void> loadOrders() async {
    loading = true;
    notifyListeners();
    try {
      orders = await _service.fetchOrders();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> changeStatus(int id, String status) async {
    await _service.updateOrderStatus(id, status);
    await loadOrders();
  }
}

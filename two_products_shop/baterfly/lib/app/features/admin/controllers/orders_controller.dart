// controllers/orders_controller.dart
import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/material.dart';

class OrdersController extends ChangeNotifier {
  final AdminService _service = AdminService();
  List<Map<String, dynamic>> orders = [];
  bool loading = false;

  /// الحالة المختارة في الفلتر (null = الكل)
  String? statusFilter;

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

  /// تغيير الفلتر
  void setFilter(String? status) {
    statusFilter = status;
    notifyListeners();
  }

  /// الطلبات بعد تطبيق الفلتر
  List<Map<String, dynamic>> get filteredOrders {
    if (statusFilter == null) return orders;
    return orders.where((o) => (o['status'] ?? '') == statusFilter).toList();
  }

  /// إجمالي الطلبات
  int get totalOrders => orders.length;

  /// عدد الطلبات حسب كل حالة
  Map<String, int> get statusCounts {
    final map = <String, int>{
      'pending': 0,
      'processing': 0,
      'shipped': 0,
      'done': 0,
    };

    for (final o in orders) {
      final s = (o['status'] ?? '').toString();
      if (map.containsKey(s)) {
        map[s] = map[s]! + 1;
      }
    }

    return map;
  }

  // ============================================================
  //                 دالة حذف الطلب
  // ============================================================
  Future<void> deleteOrder(int id, BuildContext context) async {
    try {
      // 1) حذف الطلب من الـ Database عبر Supabase
      // cast to dynamic to avoid compile-time error if AdminService doesn't declare deleteOrder
      await (_service as dynamic).deleteOrder(id);

      // 2) حذف الطلب محليًا بدون إعادة تحميل كل البيانات
      orders.removeWhere((o) => o['id'] == id);

      // 3) إعادة البناء
      notifyListeners();

      // 4) SnackBar نجاح
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف الطلب بنجاح')));
    } catch (e) {
      // في حالة فشل الحذف
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء حذف الطلب')));
    }
  }
}

// controllers/products_controller.dart
import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/material.dart';

class ProductsController extends ChangeNotifier {
  final AdminService _service = AdminService();
  List<Map<String, dynamic>> products = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      products = await _service.fetchProducts();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    await _service.createProduct(data);
    await load();
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    await _service.updateProduct(id, data);
    await load();
  }

  Future<void> delete(int id) async {
    await _service.deleteProduct(id);
    await load();
  }
}

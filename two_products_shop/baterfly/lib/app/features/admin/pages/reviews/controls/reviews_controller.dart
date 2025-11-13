// controllers/reviews_controller.dart
import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/material.dart';

class ReviewsController extends ChangeNotifier {
  final _service = AdminService();

  bool loading = false;
  List<Map<String, dynamic>> reviews = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();

    reviews = await _service.fetchReviews();

    loading = false;
    notifyListeners();
  }

  Future<void> verify(int id, bool val) async {
    await _service.verifyReview(id, val);
    await load(); // reload after update
  }
}

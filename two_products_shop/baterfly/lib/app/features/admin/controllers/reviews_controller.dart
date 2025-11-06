// controllers/reviews_controller.dart
import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/material.dart';

class ReviewsController extends ChangeNotifier {
  final AdminService _service = AdminService();
  List<Map<String, dynamic>> reviews = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      reviews = await _service.fetchReviews();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> verify(int id, bool isVerified) async {
    await _service.verifyReview(id, isVerified);
    await load();
  }
}

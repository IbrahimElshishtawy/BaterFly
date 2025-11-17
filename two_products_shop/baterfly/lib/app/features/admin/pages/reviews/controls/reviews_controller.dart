// controllers/reviews_controller.dart
// ignore_for_file: control_flow_in_finally

import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/foundation.dart';

class ReviewsController extends ChangeNotifier {
  final _service = AdminService();

  bool loading = false;
  String? errorMessage;
  List<Map<String, dynamic>> reviews = [];

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  Future<void> load() async {
    if (_disposed) return;

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.fetchReviews();

      if (_disposed) return;

      reviews = data;
      if (kDebugMode) {
        print('REVIEWS: $reviews');
      }
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('Error loading reviews: $e\n$s');
      }
      if (_disposed) return;

      errorMessage = 'حصل خطأ أثناء تحميل التقييمات';
    } finally {
      if (_disposed) return;

      loading = false;
      notifyListeners();
    }
  }

  Future<void> verify(int id, bool val) async {
    if (_disposed) return;

    if (kDebugMode) {
      print('VERIFY CALLED: id=$id, val=$val');
    }

    try {
      await _service.verifyReview(id, val);

      if (_disposed) return;

      // نعيد تحميل الريفيوز بعد التحديث
      await load();
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('Error verifying review: $e\n$s');
      }
    }
  }
}

// controllers/reviews_controller.dart
import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/foundation.dart';

class ReviewsController extends ChangeNotifier {
  final _service = AdminService();

  bool loading = false;
  String? errorMessage;
  List<Map<String, dynamic>> reviews = [];

  Future<void> load() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      reviews = await _service.fetchReviews();
      if (kDebugMode) {
        print('REVIEWS: $reviews');
      }
    } catch (e, s) {
      debugPrint('Error loading reviews: $e\n$s');
      errorMessage = 'حصل خطأ أثناء تحميل التقييمات';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> verify(int id, bool val) async {
    if (kDebugMode) {
      print('VERIFY CALLED: id=$id, val=$val');
    }

    try {
      await _service.verifyReview(id, val);
      await load(); // نعيد تحميل الريفيوز بعد التحديث
    } catch (e, s) {
      debugPrint('Error verifying review: $e\n$s');
    }
  }
}

import 'package:flutter/foundation.dart';
import '../../../data/datasources/remote/reviews_remote.dart';

class ReviewController with ChangeNotifier {
  final ReviewsRemote _remote;
  ReviewController(this._remote);

  bool loading = false;
  List<Map<String, dynamic>> items = [];

  Future<void> load(int productId) async {
    loading = true;
    notifyListeners();
    try {
      items = await _remote.fetchApproved(productId);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> add({
    required int productId,
    required int rating,
    required String comment,
    String? fullName,
  }) async {
    await _remote.addAnonymous(
      productId: productId,
      rating: rating,
      comment: comment,
      fullName: fullName,
    );
    await load(productId);
  }
}

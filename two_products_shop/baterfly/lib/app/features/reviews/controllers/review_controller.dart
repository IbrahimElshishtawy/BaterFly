import '../../../data/datasources/remote/reviews_remote.dart';

class ReviewController {
  final ReviewsRemote _remote;
  ReviewController({ReviewsRemote? remote})
    : _remote = remote ?? ReviewsRemote();

  Future<String?> add({
    required int productId,
    required String fullName,
    required int rating,
    required String comment,
  }) async {
    if (rating < 1 || rating > 5) return 'التقييم من 1 إلى 5';
    if (comment.trim().length < 20) return 'التعليق لا يقل عن 20 حرف';
    await _remote.submit(
      productId: productId,
      fullName: fullName.trim(),
      rating: rating,
      comment: comment.trim(),
    );
    return null;
  }
}

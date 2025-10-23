import '../entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews(int productId);
  Future<void> submitReview({
    required int productId,
    required String fullName,
    required int rating,
    required String comment,
  });
}

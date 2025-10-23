import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../models/review_model.dart';
import '../datasources/remote/reviews_remote.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewsRemote _remote;
  ReviewRepositoryImpl({ReviewsRemote? remote})
    : _remote = remote ?? ReviewsRemote();

  @override
  Future<List<Review>> getReviews(int productId) async {
    final data = await _remote.listApproved(productId);
    return data.map((r) => ReviewModel.fromMap(r)).toList();
  }

  @override
  Future<void> submitReview({
    required int productId,
    required String fullName,
    required int rating,
    required String comment,
  }) {
    return _remote.add(
      productId: productId,
      fullName: fullName,
      rating: rating,
      comment: comment,
    );
  }
}

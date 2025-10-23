import '../repositories/review_repository.dart';

class SubmitReviewUsecase {
  final ReviewRepository repo;
  SubmitReviewUsecase(this.repo);

  Future<void> call({
    required int productId,
    required String fullName,
    required int rating,
    required String comment,
  }) {
    return repo.submitReview(
      productId: productId,
      fullName: fullName,
      rating: rating,
      comment: comment,
    );
  }
}

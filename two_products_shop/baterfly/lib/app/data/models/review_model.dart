import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.id,
    required super.productId,
    required super.fullName,
    required super.rating,
    required super.comment,
    required super.isVerified,
    required super.status,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      productId: map['product_id'],
      fullName: map['full_name'],
      rating: map['rating'],
      comment: map['comment'],
      isVerified: map['is_verified'] ?? false,
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'product_id': productId,
    'full_name': fullName,
    'rating': rating,
    'comment': comment,
    'is_verified': isVerified,
    'status': status,
  };
}

// ignore_for_file: overridden_fields

import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  @override
  final int id;
  @override
  final int productId;
  @override
  final String fullName;
  @override
  final int rating;
  @override
  final String comment;
  @override
  final bool isVerified;
  @override
  final String status;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.fullName,
    required this.rating,
    required this.comment,
    required this.isVerified,
    required this.status,
  }) : super(
         id: id,
         productId: productId,
         fullName: fullName,
         rating: rating,
         comment: comment,
         isVerified: isVerified,
         status: status,
       );

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id']?.toint() ?? '',
      productId: map['product_id'] ?? 0,
      fullName: map['full_name'] ?? '',
      rating: (map['rating'] is int)
          ? map['rating']
          : int.tryParse(map['rating'].toString()) ?? 0,
      comment: map['comment'] ?? '',
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

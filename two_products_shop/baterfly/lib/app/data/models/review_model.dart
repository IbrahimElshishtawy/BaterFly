class ReviewModel {
  final int id;
  final int productId;
  final String fullName;
  final int rating;
  final String comment;
  final bool isVerified;
  final String status;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.fullName,
    required this.rating,
    required this.comment,
    required this.isVerified,
    required this.status,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as int,
      productId: (map['product_id'] ?? 0) as int,
      fullName: (map['customer_name'] ?? map['full_name'] ?? '') as String,
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: (map['comment'] ?? '') as String,
      isVerified: map['is_verified'] == true,
      status: (map['status'] ?? 'approved') as String,
    );
  }
}

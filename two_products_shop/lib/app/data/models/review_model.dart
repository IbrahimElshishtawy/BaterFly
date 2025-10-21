class ReviewModel {
  final int id;
  final int productId;
  final String comment;
  final int rating;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> m) => ReviewModel(
    id: m['id'] as int,
    productId: m['product_id'] as int,
    comment: m['comment'] as String,
    rating: m['rating'] as int,
    createdAt: DateTime.parse(m['created_at'] as String),
  );
}

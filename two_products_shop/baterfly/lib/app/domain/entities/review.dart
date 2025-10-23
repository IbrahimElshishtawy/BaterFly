class Review {
  final int id;
  final int productId;
  final String fullName;
  final int rating;
  final String comment;
  final bool isVerified;
  final String status;

  Review({
    required this.id,
    required this.productId,
    required this.fullName,
    required this.rating,
    required this.comment,
    required this.isVerified,
    required this.status,
  });
}

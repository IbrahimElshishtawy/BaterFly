class Product {
  final int id;
  final String name;
  final String slug;
  final double price;
  final List<String> images;
  final String? usage;
  final List<String> features;
  final bool active;
  final double avgRating;
  final int reviewsCount;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.images,
    this.usage,
    required this.features,
    required this.active,
    required this.avgRating,
    required this.reviewsCount,
  });
}

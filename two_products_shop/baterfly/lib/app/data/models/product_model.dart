import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.price,
    required super.images,
    super.usage,
    required super.features,
    required super.active,
    required super.avgRating,
    required super.reviewsCount,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      slug: map['slug'],
      price: (map['price'] as num).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      usage: map['usage'],
      features: List<String>.from(map['features'] ?? []),
      active: map['active'] ?? true,
      avgRating: (map['avg_rating'] ?? 0).toDouble(),
      reviewsCount: map['reviews_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'slug': slug,
    'price': price,
    'images': images,
    'usage': usage,
    'features': features,
    'active': active,
    'avg_rating': avgRating,
    'reviews_count': reviewsCount,
  };
}

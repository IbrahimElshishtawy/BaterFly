import 'dart:convert';
import '../../core/config/app_constants.dart';

class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromMap(Map<String, dynamic> m) {
    final imgs = (m[AppConstants.fImages] is String)
        ? List<String>.from(jsonDecode(m[AppConstants.fImages] as String))
        : List<String>.from((m[AppConstants.fImages] ?? []) as List);

    final feats = (m[AppConstants.fFeatures] is String)
        ? List<String>.from(jsonDecode(m[AppConstants.fFeatures] as String))
        : List<String>.from((m[AppConstants.fFeatures] ?? []) as List);

    return ProductModel(
      id: m[AppConstants.fId] as int,
      name: m[AppConstants.fName] as String,
      slug: m[AppConstants.fSlug] as String,
      price: (m[AppConstants.fPrice] as num).toDouble(),
      images: imgs,
      usage: m[AppConstants.fUsage] as String?,
      features: feats,
      active: (m[AppConstants.fActive] as bool?) ?? true,
      avgRating: (m[AppConstants.fAvgRating] as num?)?.toDouble() ?? 0,
      reviewsCount: (m[AppConstants.fReviewsCount] as int?) ?? 0,
    );
  }
}

class ProductModel {
  final String id;
  final String slug;
  final String name;
  final String type;
  final String description;

  final double price;
  final double avgRating;
  final int reviewsCount;

  final List<String> images;

  // تفاصيل المنتج
  final List<String> mainBenefits;
  final List<String> ingredients;
  final List<String> usage; // خطوات الاستخدام
  final List<String> safety;
  final List<String> targetAudience;
  final String countryOfOrigin;
  final String guarantee;
  final List<String> marketingPhrases;
  final List<String> storageTips;
  final List<String> highlights;

  // للـ unit test (features + usageText)
  final List<String> features;
  final String usageText;

  ProductModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.avgRating,
    required this.reviewsCount,
    required this.images,
    required this.mainBenefits,
    required this.ingredients,
    required this.usage,
    required this.safety,
    required this.targetAudience,
    required this.countryOfOrigin,
    required this.guarantee,
    required this.marketingPhrases,
    required this.storageTips,
    required this.highlights,
    required this.features,
    required this.usageText,
  });

  // ====== استخدام المشروع مع Supabase (JSON) ======
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      return [];
    }

    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return ProductModel(
      id: json['id'].toString(),
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      price: toDouble(json['price']),
      avgRating: toDouble(json['avg_rating']),
      reviewsCount: toInt(json['reviews_count']),
      images: toList(json['images']),
      mainBenefits: toList(json['main_benefits']),
      ingredients: toList(json['ingredients']),
      usage: toList(json['usage']),
      safety: toList(json['safety']),
      targetAudience: toList(json['target_audience']),
      countryOfOrigin: json['country_of_origin'] ?? '',
      guarantee: json['guarantee'] ?? '',
      marketingPhrases: toList(json['marketing_phrases']),
      storageTips: toList(json['storage_tips']),
      highlights: toList(json['highlights']),
      features: const [],
      usageText: '',
    );
  }

  // ====== للـ unit test: fromMap(map) ======
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    List<String> toList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      return [];
    }

    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return ProductModel(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      price: toDouble(map['price']),
      images: toList(map['images']),
      usageText: map['usage']?.toString() ?? '',
      features: toList(map['features']),
      avgRating: toDouble(map['avg_rating']),
      reviewsCount: toInt(map['reviews_count']),
      type: '',
      description: '',
      mainBenefits: const [],
      ingredients: const [],
      usage: const [],
      safety: const [],
      targetAudience: const [],
      countryOfOrigin: '',
      guarantee: '',
      marketingPhrases: const [],
      storageTips: const [],
      highlights: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'type': type,
      'description': description,
      'price': price,
      'avg_rating': avgRating,
      'reviews_count': reviewsCount,
      'images': images,
      'main_benefits': mainBenefits,
      'ingredients': ingredients,
      'usage': usage,
      'safety': safety,
      'target_audience': targetAudience,
      'country_of_origin': countryOfOrigin,
      'guarantee': guarantee,
      'marketing_phrases': marketingPhrases,
      'storage_tips': storageTips,
      'highlights': highlights,
    };
  }
}

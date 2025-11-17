class ProductModel {
  final String id;
  final String slug;
  final String name;
  final String type;
  final String description;

  final List<String> images;
  final List<String> mainBenefits;
  final List<String> ingredients;
  final List<String> usage;
  final List<String> safety;
  final List<String> targetAudience;

  final String countryOfOrigin;
  final String guarantee;

  final List<String> marketingPhrases;
  final List<String> storageTips;
  final List<String> highlights;

  ProductModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    required this.description,
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
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> _stringList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      return [];
    }

    return ProductModel(
      id: json['id'].toString(),
      slug: json['slug'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      images: _stringList(json['images']),
      mainBenefits: _stringList(json['main_benefits']),
      ingredients: _stringList(json['ingredients']),
      usage: _stringList(json['usage']),
      safety: _stringList(json['safety']),
      targetAudience: _stringList(json['target_audience']),
      countryOfOrigin: json['country_of_origin'] as String? ?? '',
      guarantee: json['guarantee'] as String? ?? '',
      marketingPhrases: _stringList(json['marketing_phrases']),
      storageTips: _stringList(json['storage_tips']),
      highlights: _stringList(json['highlights']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'type': type,
      'description': description,
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

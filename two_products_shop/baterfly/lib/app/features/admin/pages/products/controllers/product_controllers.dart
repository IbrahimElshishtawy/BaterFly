import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/product_model.dart';

class ProductControllers {
  final name = TextEditingController();
  final slug = TextEditingController();
  final type = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  final country = TextEditingController();
  final guarantee = TextEditingController();

  final mainBenefits = TextEditingController();
  final ingredients = TextEditingController();
  final usage = TextEditingController();
  final safety = TextEditingController();
  final targetAudience = TextEditingController();
  final marketing = TextEditingController();
  final storage = TextEditingController();
  final highlights = TextEditingController();

  void fillFromProduct(ProductModel p) {
    name.text = p.name;
    slug.text = p.slug;
    type.text = p.type;
    price.text = p.price == 0 ? '' : p.price.toString();
    desc.text = p.description;
    country.text = p.countryOfOrigin;
    guarantee.text = p.guarantee;

    mainBenefits.text = p.mainBenefits.join('\n');
    ingredients.text = p.ingredients.join('\n');
    usage.text = p.usage.join('\n');
    safety.text = p.safety.join('\n');
    targetAudience.text = p.targetAudience.join('\n');
    marketing.text = p.marketingPhrases.join('\n');
    storage.text = p.storageTips.join('\n');
    highlights.text = p.highlights.join('\n');
  }

  void clearAll() {
    name.clear();
    slug.clear();
    type.clear();
    price.clear();
    desc.clear();
    country.clear();
    guarantee.clear();

    mainBenefits.clear();
    ingredients.clear();
    usage.clear();
    safety.clear();
    targetAudience.clear();
    marketing.clear();
    storage.clear();
    highlights.clear();
  }

  void copyFromExisting() {
    name.text = '${name.text} (نسخة)';
    slug.clear();
  }

  ProductModel buildProduct({
    required int? id,
    required List<String> images,
    required ProductModel? base,
  }) {
    List<String> lines(String t) =>
        t.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return ProductModel(
      id: id?.toString(),
      slug: slug.text.trim(),
      name: name.text.trim(),
      type: type.text.trim(),
      description: desc.text.trim(),
      price: double.tryParse(price.text) ?? 0,
      avgRating: base?.avgRating ?? 0,
      reviewsCount: base?.reviewsCount ?? 0,
      images: images,
      mainBenefits: lines(mainBenefits.text),
      ingredients: lines(ingredients.text),
      usage: lines(usage.text),
      safety: lines(safety.text),
      targetAudience: lines(targetAudience.text),
      countryOfOrigin: country.text.trim(),
      guarantee: guarantee.text.trim(),
      marketingPhrases: lines(marketing.text),
      storageTips: lines(storage.text),
      highlights: lines(highlights.text),
      features: base?.features ?? [],
      usageText: base?.usageText ?? '',
    );
  }
}

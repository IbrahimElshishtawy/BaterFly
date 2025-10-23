// ignore_for_file: depend_on_referenced_packages

import 'package:baterfly/app/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductModel', () {
    test('fromMap should correctly parse valid map', () {
      final map = {
        'id': 1,
        'name': 'Test Product',
        'slug': 'test-product',
        'price': 199.99,
        'images': ['img1.webp', 'img2.webp'],
        'usage': 'Use daily',
        'features': ['Fast', 'Reliable'],
        'avg_rating': 4.5,
        'reviews_count': 10,
      };

      final model = ProductModel.fromMap(map);

      expect(model.id, 1);
      expect(model.name, 'Test Product');
      expect(model.slug, 'test-product');
      expect(model.price, 199.99);
      expect(model.images.length, 2);
      expect(model.features.length, 2);
      expect(model.avgRating, 4.5);
      expect(model.reviewsCount, 10);
    });
  });
}

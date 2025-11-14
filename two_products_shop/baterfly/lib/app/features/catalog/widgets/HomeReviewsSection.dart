// ignore_for_file: file_names

import 'package:baterfly/app/core/widgets/Reviews_Slider.dart';
import 'package:baterfly/app/data/models/review_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeReviewsSection extends StatelessWidget {
  const HomeReviewsSection({super.key});

  Future<List<ReviewModel>> _loadVerifiedReviews() async {
    final db = Supabase.instance.client;

    try {
      final res = await db
          .from('product_reviews')
          .select('id, product_id, rating, comment, is_verified, customer_name')
          .eq('is_verified', true)
          .order('created_at', ascending: false)
          .limit(10);

      if (kDebugMode) {
        print('HOME VERIFIED RAW: $res');
      }

      final list = List<Map<String, dynamic>>.from(res as List);

      return list.map((m) {
        return ReviewModel(
          id: m['id'] as int,
          productId: (m['product_id'] ?? 0) as int,
          fullName: (m['customer_name'] ?? '') as String,
          rating: (m['rating'] as num?)?.toInt() ?? 0,
          comment: (m['comment'] ?? '') as String,
          isVerified: m['is_verified'] == true,
        );
      }).toList();
    } catch (e, s) {
      if (kDebugMode) {
        print('ERROR LOADING HOME REVIEWS: $e\n$s');
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewModel>>(
      future: _loadVerifiedReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'حصل خطأ أثناء تحميل التقييمات',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final reviews = snapshot.data!;

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: ReviewsSlider(reviews: reviews)),
          ),
        );
      },
    );
  }
}

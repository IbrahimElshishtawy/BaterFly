import 'package:baterfly/app/core/widgets/Reviews_Slider.dart';
import 'package:baterfly/app/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeReviewsSection extends StatelessWidget {
  const HomeReviewsSection({super.key});

  Future<List<ReviewModel>> _loadVerifiedReviews() async {
    final db = Supabase.instance.client;

    final res = await db
        .from('product_reviews')
        .select() // أو حدد الأعمدة لو حابب
        .eq('is_verified', true)
        .order('created_at', ascending: false)
        .limit(10);

    final list = List<Map<String, dynamic>>.from(res as List);

    return list.map((m) => ReviewModel.fromMap(m)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewModel>>(
      future: _loadVerifiedReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // لودينج بسيط
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // لو مفيش ريفيوز موثقة → ما نعرضش السكشن
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

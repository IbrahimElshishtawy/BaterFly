// pages/reviews_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/reviews_controller.dart';
import 'widgets/reviews_stats_card.dart';
import 'widgets/reviews_filter_bar.dart';
import 'widgets/reviews_list.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  /// all / verified / unverified
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReviewsController()..load(),
      child: Consumer<ReviewsController>(
        builder: (context, ctrl, _) {
          if (ctrl.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.reviews.isEmpty) {
            return const Center(child: Text("لا توجد تقييمات حتى الآن"));
          }

          final total = ctrl.reviews.length;
          final verified = ctrl.reviews
              .where((r) => r['is_verified'] == true)
              .length;
          final unverified = total - verified;

          // فلترة حسب الاختيار
          final reviews = ctrl.reviews.where((r) {
            if (_filter == 'verified') {
              return r['is_verified'] == true;
            } else if (_filter == 'unverified') {
              return r['is_verified'] != true;
            }
            return true; // all
          }).toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 600 && !isWide;

              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      children: [
                        // 🔹 هيدر
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.rate_review_outlined,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'إدارة التقييمات',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'تحديث',
                                onPressed: () => ctrl.load(),
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        ),

                        //  كارت الإحصائيات
                        ReviewsStatsCard(
                          total: total,
                          verified: verified,
                          unverified: unverified,
                          isWide: isWide,
                        ),

                        const SizedBox(height: 8),

                        //  الفلتر
                        ReviewsFilterBar(
                          currentFilter: _filter,
                          onFilterChanged: (value) {
                            setState(() => _filter = value);
                          },
                        ),

                        const SizedBox(height: 8),

                        //  قائمة التقييمات
                        Expanded(
                          child: ReviewsList(
                            reviews: reviews,
                            isWide: isWide,
                            isTablet: isTablet,
                            onToggleVerified: (id, val) => ctrl.verify(id, val),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

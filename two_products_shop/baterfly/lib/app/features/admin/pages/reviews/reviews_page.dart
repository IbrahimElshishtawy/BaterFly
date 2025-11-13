// pages/reviews_page.dart
import 'package:baterfly/app/features/admin/pages/reviews/controls/reviews_controller.dart';
import 'package:baterfly/app/features/admin/pages/reviews/widgets/reviews_list.dart';
import 'package:baterfly/app/features/admin/pages/reviews/widgets/reviews_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
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

          // لو حصل خطأ في الـ load
          if (ctrl.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ctrl.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ctrl.load(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          // فلترة الريفيوز حسب الفلتر الحالي
          final reviews = ctrl.reviews.where((r) {
            final bool isVerified = r['is_verified'] == true;

            if (_filter == 'verified') return isVerified;
            if (_filter == 'unverified') return !isVerified;
            return true;
          }).toList();

          // حساب الإحصائيات
          final int verifiedCount = ctrl.reviews.where((r) {
            return r['is_verified'] == true;
          }).length;

          final int unverifiedCount = ctrl.reviews.where((r) {
            return r['is_verified'] != true;
          }).length;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 700;

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => ctrl.load(),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),

                  // Stats
                  ReviewsStatsCard(
                    total: ctrl.reviews.length,
                    verified: verifiedCount,
                    unverified: unverifiedCount,
                    isWide: isWide,
                  ),

                  const SizedBox(height: 10),

                  // Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _filterChip('الكل', 'all'),
                        const SizedBox(width: 8),
                        _filterChip('الموثّق فقط', 'verified'),
                        const SizedBox(width: 8),
                        _filterChip('غير الموثّق', 'unverified'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // List
                  Expanded(
                    child: ReviewsList(
                      reviews: reviews,
                      isWide: isWide,
                      isTablet: isTablet,
                      onToggleVerified: (id, val) =>
                          ctrl.verify(id, val), // تحديث التوثيق
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _filterChip(String label, String key) {
    final bool selected = _filter == key;

    return ChoiceChip(
      selected: selected,
      label: Text(label),
      selectedColor: Colors.deepPurple.shade100,
      onSelected: (_) => setState(() => _filter = key),
      labelStyle: TextStyle(
        color: selected ? Colors.deepPurple : Colors.black87,
      ),
    );
  }
}

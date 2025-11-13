// pages/reviews_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/reviews_controller.dart';

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

                        // 🔹 كارت الإحصائيات
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 14.0,
                              ),
                              child: isWide
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'إجمالي التقييمات',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '$total',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _statChip(
                                                label: 'الموثّق',
                                                value: verified,
                                                color: Colors.green,
                                              ),
                                              _statChip(
                                                label: 'غير الموثّق',
                                                value: unverified,
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'إجمالي التقييمات',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$total',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 8,
                                          children: [
                                            _statChip(
                                              label: 'الموثّق',
                                              value: verified,
                                              color: Colors.green,
                                            ),
                                            _statChip(
                                              label: 'غير الموثّق',
                                              value: unverified,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 فلتر (الكل / الموثّق / غير الموثّق)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: const Text('الكل'),
                                selected: _filter == 'all',
                                onSelected: (_) =>
                                    setState(() => _filter = 'all'),
                                selectedColor: Colors.deepPurple.shade50,
                                labelStyle: TextStyle(
                                  color: _filter == 'all'
                                      ? Colors.deepPurple
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text('الموثّق فقط'),
                                selected: _filter == 'verified',
                                onSelected: (_) =>
                                    setState(() => _filter = 'verified'),
                                selectedColor: Colors.green.withOpacity(0.12),
                                labelStyle: TextStyle(
                                  color: _filter == 'verified'
                                      ? Colors.green
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text('غير الموثّق'),
                                selected: _filter == 'unverified',
                                onSelected: (_) =>
                                    setState(() => _filter = 'unverified'),
                                selectedColor: Colors.orange.withOpacity(0.12),
                                labelStyle: TextStyle(
                                  color: _filter == 'unverified'
                                      ? Colors.orange
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 قائمة التقييمات
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(
                              isTablet || isWide ? 16 : 8,
                            ),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemCount: reviews.length,
                            itemBuilder: (context, i) {
                              final r = reviews[i];

                              return Card(
                                elevation: 1.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  title: Text(
                                    r['product_name'] ?? 'منتج غير معروف',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Text(
                                        'Order: ${r['order_no'] ?? '-'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Rating: ⭐ ${r['rating'] ?? 0}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      if ((r['comment'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        Text(
                                          r['comment'],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              (r['is_verified'] == true
                                                      ? Colors.green
                                                      : Colors.orange)
                                                  .withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          r['is_verified'] == true
                                              ? 'مُوثَّق'
                                              : 'غير مُوثَّق',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: r['is_verified'] == true
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Switch(
                                        value: r['is_verified'] == true,
                                        onChanged: (val) =>
                                            ctrl.verify(r['id'] as int, val),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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

  Widget _statChip({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

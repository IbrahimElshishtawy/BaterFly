// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/reviews_controller.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

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

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: ctrl.reviews.length,
            itemBuilder: (context, i) {
              final r = ctrl.reviews[i];

              return Card(
                elevation: 3,
                child: ListTile(
                  title: Text(
                    r['product_name'] ?? 'منتج غير معروف',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text("Order: ${r['order_no'] ?? '-'}"),
                      Text("Rating: ⭐ ${r['rating'] ?? 0}"),
                      const SizedBox(height: 4),
                      Text(r['comment'] ?? ''),
                    ],
                  ),
                  trailing: Switch(
                    value: r['is_verified'] == true,
                    onChanged: (val) => ctrl.verify(r['id'] as int, val),
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

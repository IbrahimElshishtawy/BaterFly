// pages/reviews_page.dart
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
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemCount: ctrl.reviews.length,
            itemBuilder: (context, i) {
              final r = ctrl.reviews[i];
              return Card(
                child: ListTile(
                  title: Text(r['full_name'] ?? 'مستخدم'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rating: ${r['ratting'] ?? '-'}'),
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

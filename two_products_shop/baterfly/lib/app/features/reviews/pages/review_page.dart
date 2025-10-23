import 'package:flutter/material.dart';
import '../widgets/review_section.dart';

class ReviewPage extends StatelessWidget {
  final int productId;
  const ReviewPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقييمات')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ReviewSection(productId: productId),
      ),
    );
  }
}

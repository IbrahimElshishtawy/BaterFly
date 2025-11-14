import 'package:flutter/material.dart';
import '../widgets/review_section.dart';

class ReviewPage extends StatelessWidget {
  final int productId;
  final String orderNo;
  const ReviewPage({super.key, required this.productId, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقييمات')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ReviewSection(productId: productId, orderNo: orderNo),
      ),
    );
  }
}

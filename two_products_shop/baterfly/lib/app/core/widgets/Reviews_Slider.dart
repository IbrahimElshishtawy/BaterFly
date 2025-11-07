// ignore_for_file: deprecated_member_use, file_names

import 'package:baterfly/app/data/models/review_model.dart';
import 'package:flutter/material.dart';

class ReviewsSlider extends StatefulWidget {
  final List<ReviewModel> reviews;

  const ReviewsSlider({super.key, required this.reviews});

  @override
  State<ReviewsSlider> createState() => _ReviewsSliderState();
}

class _ReviewsSliderState extends State<ReviewsSlider>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // تبديل التعليقات كل 3 ثواني
    Future.delayed(const Duration(seconds: 3), _changeReview);
  }

  void _changeReview() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      setState(() {
        index = (index + 1) % widget.reviews.length;
      });
      _controller.forward();
    });

    Future.delayed(const Duration(seconds: 3), _changeReview);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return const Center(child: Text("لا يوجد تقييمات بعد"));
    }

    final item = widget.reviews[index];

    return FadeTransition(
      opacity: _fade,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return Icon(
                  i < item.rating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber,
                );
              }),
            ),
            const SizedBox(height: 6),
            Text(
              item.comment,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

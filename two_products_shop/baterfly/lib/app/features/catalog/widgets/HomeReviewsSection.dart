// ignore_for_file: file_names

import 'package:baterfly/app/data/models/review_model.dart';
import 'package:flutter/material.dart';

class ReviewsSlider extends StatefulWidget {
  final List<ReviewModel> reviews;

  const ReviewsSlider({super.key, required this.reviews});

  @override
  State<ReviewsSlider> createState() => _ReviewsSliderState();
}

class _ReviewsSliderState extends State<ReviewsSlider> {
  late final PageController _pageController;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8, // يخلي الكارت اللي في النص كبير والباقي باين وراه
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _safeName(String name) {
    if (name.trim().isEmpty) return 'عميل';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.reviews.length,
      onPageChanged: (i) {
        setState(() => _current = i);
      },
      itemBuilder: (context, index) {
        final review = widget.reviews[index];

        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 0;
            if (_pageController.position.haveDimensions) {
              value = _pageController.page! - index;
            } else {
              value = _current - index.toDouble();
            }

            // قيمة من 0 إلى 1 لتكبير/تصغير الكارت
            value = (1 - (value.abs() * 0.25)).clamp(0.85, 1.0);

            final double scale = value;
            final double opacity = 0.5 + (value - 0.85) * 3; // تقريباً 0.5 - 1

            return Center(
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.4, 1.0),
                  child: _buildCard(review),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard(ReviewModel review) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white.withOpacity(0.16),
            Colors.white.withOpacity(0.04),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // أول صف: الاسم + تقييم موثّق + النجمة والرقم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الاسم و"تقييم موثّق"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _safeName(review.fullName),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.verified,
                              color: Colors.greenAccent,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'تقييم موثّق',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // التقييم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // نص التعليق
          Expanded(
            child: Text(
              review.comment,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

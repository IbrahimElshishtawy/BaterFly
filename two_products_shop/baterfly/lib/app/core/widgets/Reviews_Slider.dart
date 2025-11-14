import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/review_model.dart';

class ReviewsSlider extends StatelessWidget {
  final List<ReviewModel> reviews;

  const ReviewsSlider({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: reviews.length,
        controller: PageController(viewportFraction: 0.85),
        itemBuilder: (context, index) {
          final r = reviews[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐ التقييم
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      r.rating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 👤 اسم العميل
                Text(
                  r.fullName.isNotEmpty ? r.fullName : "عميل",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),

                // 💬 التعليق
                Expanded(
                  child: Text(
                    r.comment,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

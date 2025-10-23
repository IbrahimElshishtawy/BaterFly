import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/remote/reviews_remote.dart';
import '../controllers/review_controller.dart';
import 'star_rating.dart';

class ReviewSection extends StatefulWidget {
  final int productId;
  const ReviewSection({super.key, required this.productId});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final _remote = ReviewsRemote();
  final _ctrl = ReviewController();
  late Future<List<Map<String, dynamic>>> f;
  final name = TextEditingController();
  final comment = TextEditingController();
  int rating = 5;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    f = _remote.listApproved(widget.productId);
  }

  Future<void> _submit() async {
    setState(() => sending = true);
    final err = await _ctrl.add(
      productId: widget.productId,
      fullName: name.text,
      rating: rating,
      comment: comment.text,
    );
    setState(() => sending = false);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    name.clear();
    comment.clear();
    setState(() => f = _remote.listApproved(widget.productId));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم إرسال التقييم للمراجعة')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('التقييمات', style: AppTextStyles.title),
        const SizedBox(height: 12),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: f,
          builder: (_, s) {
            if (!s.hasData)
              return const Center(child: CircularProgressIndicator());
            final items = s.data!;
            if (items.isEmpty) return const Text('لا توجد تقييمات بعد');
            return Column(
              children: items.map((r) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(r['full_name']),
                  subtitle: Text(r['comment']),
                  trailing: StarRating(value: (r['rating'] as num).toDouble()),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        const Text('أضف تقييمك', style: AppTextStyles.title),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            final idx = i + 1;
            return IconButton(
              onPressed: () => setState(() => rating = idx),
              icon: Icon(
                idx <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: Colors.amber,
              ),
            );
          }),
        ),
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'الاسم الكامل'),
        ),
        TextField(
          controller: comment,
          decoration: const InputDecoration(labelText: 'اكتب تعليقًا مفيدًا'),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: sending ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: sending
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('إرسال'),
        ),
      ],
    );
  }
}

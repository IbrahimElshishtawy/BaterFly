import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/validators.dart';

class ReviewSection extends StatefulWidget {
  final int productId;
  const ReviewSection({super.key, required this.productId});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final _comment = TextEditingController();
  int _rating = 0;
  bool _loading = false;
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final res = await Supa.client
        .from(AppConstants.tblReviews)
        .select()
        .eq('product_id', widget.productId)
        .order('created_at', ascending: false);
    setState(() => _reviews = (res as List).cast<Map<String, dynamic>>());
  }

  Future<void> _submit() async {
    if (Validators.comment(_comment.text) != null ||
        Validators.rating(_rating) != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اكتب تعليق واختر تقييم')));
      return;
    }
    setState(() => _loading = true);
    try {
      await Supa.client.from(AppConstants.tblReviews).insert({
        'product_id': widget.productId,
        'comment': _comment.text.trim(),
        'rating': _rating,
      });
      _comment.clear();
      _rating = 0;
      await _fetchReviews();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text(
          'آراء العملاء',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (final r in _reviews)
          ListTile(
            title: Text(r['comment'] ?? ''),
            subtitle: Row(
              children: List.generate(
                r['rating'] ?? 0,
                (_) => const Icon(Icons.star, size: 16, color: Colors.amber),
              ),
            ),
          ),
        const SizedBox(height: 12),
        TextField(
          controller: _comment,
          decoration: const InputDecoration(labelText: 'اكتب تعليقك'),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final filled = i < _rating;
            return IconButton(
              icon: Icon(
                Icons.star,
                color: filled ? Colors.amber : Colors.grey,
              ),
              onPressed: () => setState(() => _rating = i + 1),
            );
          }),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const CircularProgressIndicator()
                : const Text('إرسال التقييم'),
          ),
        ),
      ],
    );
  }
}

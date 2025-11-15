// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewSection extends StatefulWidget {
  final String orderNo;
  final String productName;

  const ReviewSection({
    super.key,
    required this.orderNo,
    required this.productName,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  int selectedRating = 0;
  final TextEditingController commentCtrl = TextEditingController();
  bool isSubmitting = false;
  bool isSent = false;

  Future<void> submitReview() async {
    if (selectedRating == 0 || commentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ من فضلك اختر تقييم واكتب تعليق")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await Supabase.instance.client.from("product_reviews").insert({
        "order_no": widget.orderNo,
        "product_name": widget.productName,
        "rating": selectedRating,
        "comment": commentCtrl.text,
      });

      setState(() => isSent = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ شكراً لك! تم إرسال تقييمك بنجاح")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ حدث خطأ أثناء الإرسال: $e")));
    }

    setState(() => isSubmitting = false);
  }

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "⭐ قيم تجربتك معنا",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return IconButton(
                  onPressed: isSent
                      ? null
                      : () {
                          setState(() => selectedRating = i + 1);
                        },
                  icon: Icon(
                    i < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            // 💬 Comment
            TextField(
              controller: commentCtrl,
              enabled: !isSent,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "شاركنا رأيك...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSent ? null : submitReview,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isSent ? Colors.green : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        isSent ? "تم إرسال التقييم" : "إرسال التقييم",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

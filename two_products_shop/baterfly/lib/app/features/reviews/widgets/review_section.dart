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
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();
  bool isSubmitting = false;
  bool isSent = false;

  Future<void> submitReview() async {
    if (selectedRating == 0 ||
        nameCtrl.text.trim().isEmpty ||
        commentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ من فضلك اختر تقييم، واكتب اسمك وتعليقك"),
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await Supabase.instance.client.from("product_reviews").insert({
        "order_no": widget.orderNo,
        "product_name": widget.productName,
        "rating": selectedRating,
        "comment": commentCtrl.text.trim(),

        "customer_name": nameCtrl.text.trim(),
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
    nameCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: !isSent,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            hintTextDirection: TextDirection.rtl,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.orangeAccent),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "أضف تقييمك",
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // النجوم
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(5, (i) {
                final filled = i < selectedRating;
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: isSent
                      ? null
                      : () {
                          setState(() => selectedRating = i + 1);
                        },
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            _buildInput(
              label: "الاسم الكامل",
              hint: "اكتب اسمك هنا",
              controller: nameCtrl,
            ),

            const SizedBox(height: 14),

            _buildInput(
              label: "تعليقك",
              hint: "اكتب تعليقًا مفيدًا عن تجربتك",
              controller: commentCtrl,
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: isSent ? null : submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSent
                      ? Colors.green
                      : const Color(0xffFF007A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isSent ? "تم إرسال تقييمك" : "إرسال",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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

import 'package:flutter/material.dart';
import 'thank_you_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  bool sending = false;

  void confirmOrder() async {
    setState(() => sending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => sending = false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ThankYouPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text('شراء ${p['name']}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'الاسم الكامل'),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            ),
            TextField(
              controller: address,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: sending ? null : confirmOrder,
              child: sending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('تأكيد الطلب', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }
}

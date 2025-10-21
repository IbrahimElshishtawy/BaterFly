import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';

class ThankYouPage extends StatelessWidget {
  final dynamic orderNo;
  const ThankYouPage({super.key, this.orderNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تم الطلب بنجاح')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 96),
            const SizedBox(height: 16),
            const Text('شكرًا لثقتك بنا!'),
            Text('رقم الطلب: $orderNo'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (_) => false,
              ),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}

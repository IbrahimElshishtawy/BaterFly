import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({
    super.key,
    required String orderNo,
    required String productName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text('تم تأكيد الطلب بنجاح!', style: AppTextStyles.title),
            SizedBox(height: 10),
            Text(
              'سيتم التواصل معك قريبًا لتأكيد التفاصيل.',
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:baterfly/app/core/widgets/footer_links/footer_helpers.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/nav_link.dart';
import 'package:flutter/material.dart';

class FooterMobileColumns extends StatelessWidget {
  const FooterMobileColumns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'منتجات عناية واكسسوارات مختارة بعناية.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        const Text(
          'شحن سريع داخل مصر واسترجاع خلال 14 يوم.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 18,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            // زر تحميل APK
            const FooterLink(
              text: 'تحميل تطبيق ButterFly (APK)',
              url:
                  'https://github.com/IbrahimElshishtawy/BaterFly/releases/download/v1.0.0/app-release.apk',
            ),

            NavLink(text: 'سياسة الاستبدال والاسترجاع', route: '/returns'),
            NavLink(text: 'سياسة الشحن', route: '/shipping'),
            NavLink(text: 'الدعم الفني واتساب', route: '/support'),
          ],
        ),
      ],
    );
  }
}

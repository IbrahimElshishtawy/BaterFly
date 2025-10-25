import 'package:flutter/material.dart';
import 'footer_helpers.dart';

class FooterMobileColumns extends StatelessWidget {
  const FooterMobileColumns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FooterMuted('منتجات عناية واكسسوارات مختارة بعناية.'),
        const SizedBox(height: 8),
        const FooterMuted('شحن سريع داخل مصر واسترجاع خلال 14 يوم.'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _NavLink(text: 'سياسة الاستبدال والاسترجاع', route: '/returns'),
            _NavLink(text: 'سياسة الشحن', route: '/shipping'),
            _NavLink(text: 'الدعم الفني واتساب', route: '/support'),
          ],
        ),
      ],
    );
  }
}

// عنصر مخصص للتنقل الداخلي داخل التطبيق
class _NavLink extends StatelessWidget {
  final String text;
  final String route;
  const _NavLink({required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

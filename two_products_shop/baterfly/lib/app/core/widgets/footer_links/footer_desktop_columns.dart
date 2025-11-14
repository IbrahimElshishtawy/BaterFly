import 'package:baterfly/app/core/widgets/site_app_bar/nav_link.dart';
import 'package:flutter/material.dart';
import 'footer_helpers.dart';

class FooterDesktopColumns extends StatelessWidget {
  const FooterDesktopColumns({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عمود معلومات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FooterColHeader('BaterFly'),
              SizedBox(height: 10),
              FooterMuted('منتجات عناية واكسسوارات مختارة بعناية.'),
              FooterMuted('شحن سريع داخل مصر واسترجاع خلال 14 يوم.'),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // عمود السياسات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              NavLink(text: 'سياسة الاستبدال والاسترجاع', route: '/returns'),
              NavLink(text: 'سياسة الشحن', route: '/shipping'),
              NavLink(text: 'الدعم الفني والتواصل', route: '/support'),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // عمود الدعم والتواصل
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FooterColHeader('الدعم والتواصل'),
              SizedBox(height: 10),

              // واتساب
              FooterLink(
                text: 'الدعم الفني عبر واتساب',
                url: 'https://wa.me/201098338348',
              ),

              // فيسبوك
              FooterLink(
                text: 'فيسبوك',
                url: 'https://www.facebook.com/share/1AHY1dexwG/',
              ),

              // انستجرام
              FooterLink(
                text: 'إنستجرام',
                url: 'https://www.instagram.com/m.almounir/',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

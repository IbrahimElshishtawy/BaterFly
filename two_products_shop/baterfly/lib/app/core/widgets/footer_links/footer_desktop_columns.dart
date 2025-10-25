import 'package:flutter/material.dart';
import 'footer_helpers.dart';

class FooterDesktopColumns extends StatelessWidget {
  const FooterDesktopColumns({super.key});

  @override
  Widget build(BuildContext context) {
    final colTitle = TextStyle(
      color: Colors.white.withOpacity(0.92),
      fontWeight: FontWeight.w800,
      fontSize: 14,
      letterSpacing: .2,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عمود معلومات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FooterColHeader('لمسة حرير'),
              SizedBox(height: 10),
              FooterMuted('منتجات عناية واكسسوارات مختارة بعناية.'),
              FooterMuted('شحن سريع داخل مصر واسترجاع خلال 14 يوم.'),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // عمود سياسات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FooterColHeader('السياسات'),
              SizedBox(height: 10),
              FooterLink(
                text: 'سياسة الاستبدال والاسترجاع',
                url: 'https://example.com/returns',
              ),
              FooterLink(
                text: 'سياسة الشحن',
                url: 'https://example.com/shipping',
              ),
              FooterLink(
                text: 'الأسئلة الشائعة',
                url: 'https://example.com/faq',
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // عمود الدعم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FooterColHeader('الدعم والتواصل'),
              SizedBox(height: 10),
              FooterLink(
                text: 'الدعم الفني واتساب',
                url: 'https://wa.me/201234567890',
              ),
              FooterLink(text: 'فيسبوك', url: 'https://facebook.com'),
              FooterLink(text: 'إنستغرام', url: 'https://instagram.com'),
            ],
          ),
        ),
      ],
    );
  }
}

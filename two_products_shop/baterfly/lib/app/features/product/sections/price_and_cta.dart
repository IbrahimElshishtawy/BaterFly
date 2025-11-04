// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/section_card.dart';

class PriceAndCTA extends StatelessWidget {
  const PriceAndCTA({super.key});

  // دالة لفتح الواتساب
  void _openWhatsApp() async {
    const phoneNumber = '+201234567890'; // حط رقمك هنا
    final message = Uri.encodeComponent(
      "مرحبًا، أريد الاستفسار عن سعر المنتج 💬",
    );
    final url = Uri.parse('https://wa.me/$phoneNumber?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('لا يمكن فتح WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 700;

    // المنتج اللي هيتبعت للـ Checkout
    final myProduct = {'id': 1, 'name': 'منتج تجريبي', 'price': 2000};

    return SectionCard(
      title: "احجزي الآن واحصلي على نتائج فورية ✨",
      transparent: true,
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: isWeb ? 20 : 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 جملة الاستفسار عن السعر
            GestureDetector(
              onTap: _openWhatsApp,
              child: Text(
                "للاستفسار عن السعر اضغطي هنا 💬",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.pinkAccent.shade100,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.pinkAccent.shade100,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // 🔹 زرار الطلب العادي
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.checkout,
                    arguments: {'product': myProduct},
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 53, 39, 176),
                        Color(0xFFE91E63),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          64,
                          93,
                          255,
                        ).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    "اطلبي الآن",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
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

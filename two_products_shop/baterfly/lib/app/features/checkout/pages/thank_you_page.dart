// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:baterfly/app/features/reviews/widgets/review_section.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThankYouPage extends StatefulWidget {
  final String orderNo;
  final String productName;

  const ThankYouPage({
    super.key,
    required this.orderNo,
    required this.productName,
  });

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width > 600
                          ? 500
                          : double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                            child: Lottie.network(
                              "https://assets1.lottiefiles.com/packages/lf20_jbrw3hcz.json",
                              repeat: false,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "✅ تم تأكيد الطلب بنجاح!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "رقم الطلب: ${widget.orderNo}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "المنتج: ButterFly ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 30),

                          ReviewSection(
                            orderNo: widget.orderNo,
                            productId: int.tryParse(widget.productName) ?? 0,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "العودة للرئيسية",
                                style: TextStyle(
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
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: FooterLinks()),
            ],
          ),
        ],
      ),
    );
  }
}

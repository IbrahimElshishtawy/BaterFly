// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/data/models/policy_models.dart';
import 'package:baterfly/app/features/policies/widget/Policy_Item.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:baterfly/app/services/supabase/content_service.dart';
import 'package:flutter/material.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contentService = ContentService();

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(), // الخلفية
          FutureBuilder<PolicyPageModel>(
            future: contentService.getPolicyPage('shipping'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'حدث خطأ أثناء تحميل سياسة الشحن',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'لا توجد بيانات متاحة لسياسة الشحن',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final data = snapshot.data!;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // العنوان الرئيسي
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_shipping_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data.mainTitle,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // فقرة تمهيدية من Supabase
                              if (data.introText != null &&
                                  data.introText!.isNotEmpty)
                                Text(
                                  data.introText!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.8,
                                    color: Colors.white,
                                  ),
                                ),

                              const SizedBox(height: 28),

                              // البنود من Supabase
                              ...data.items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: PolicyItem(
                                    number: item.number ?? '',
                                    title: item.title,
                                    text: item.body,
                                    textColor: Colors.white,
                                    bgColor: Colors.white24,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // ملاحظة ختامية من Supabase
                              if (data.noteText != null &&
                                  data.noteText!.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white30),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          data.noteText!,
                                          style: const TextStyle(
                                            fontSize: 15.5,
                                            height: 1.6,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Footer
                  const SliverToBoxAdapter(child: FooterLinks()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

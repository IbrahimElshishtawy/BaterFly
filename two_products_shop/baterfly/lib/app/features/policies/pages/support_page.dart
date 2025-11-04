// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/features/policies/widget/Contact_Item.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(), // الخلفية
          CustomScrollView(
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
                          // العنوان
                          Row(
                            children: const [
                              Icon(
                                Icons.headset_mic_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'خدمة الدعم الفني والتواصل',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // فقرة ترحيبية
                          const Text(
                            'يسعدنا دائمًا تواصلك معنا لأي استفسار أو ملاحظة تتعلق بطلباتك أو منتجاتنا. فريق خدمة العملاء متاح لمساعدتك عبر الوسائل التالية:',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // طرق التواصل
                          const ContactItem(
                            icon: Icons.chat_outlined,
                            color: Color(0xFF25D366),
                            title: 'واتساب الدعم الفني',
                            text:
                                'تواصل مباشرة مع فريق خدمة العملاء على مدار الساعة.',
                            url: 'https://wa.me/201234567890',
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),
                          const ContactItem(
                            icon: Icons.email_outlined,
                            color: Color(0xFF4285F4),
                            title: 'البريد الإلكتروني',
                            text:
                                'يمكنك مراسلتنا عبر البريد للحصول على دعم أو تقديم ملاحظات.',
                            url: 'mailto:support@lamsethareer.com',
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),
                          const ContactItem(
                            icon: Icons.phone_in_talk_outlined,
                            color: Color(0xFFFF9800),
                            title: 'الاتصال الهاتفي',
                            text:
                                'متاح يوميًا من الساعة 10 صباحًا حتى 8 مساءً.',
                            url: 'tel:+201234567890',
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 36),

                          // نص ختامي
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'يرجى تزويدنا برقم الطلب عند التواصل لتسريع عملية المساعدة.',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Footer
              const SliverToBoxAdapter(child: FooterLinks()),
            ],
          ),
        ],
      ),
    );
  }
}

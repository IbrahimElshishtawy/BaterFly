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
    // رقم التليفون في فورمات دولي (مصر)

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
                            'يسعدنا دائمًا تواصلك معنا لأي استفسار أو ملاحظة تتعلق بطلباتك أو منتجاتنا. '
                            'فريق خدمة العملاء متاح لمساعدتك عبر وسائل التواصل التالية:',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // واتساب
                          const ContactItem(
                            icon: Icons.chat_outlined,
                            color: Color(0xFF25D366),
                            title: 'واتساب الدعم الفني',
                            text:
                                'تواصل مباشرة مع فريق خدمة العملاء على رقم الواتساب الرسمي.',
                            // 201098338348 بدون علامة +
                            url: 'https://wa.me/201098338348',
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),

                          // البريد الإلكتروني
                          const ContactItem(
                            icon: Icons.email_outlined,
                            color: Color(0xFF4285F4),
                            title: 'البريد الإلكتروني',
                            text:
                                'يمكنك مراسلتنا عبر البريد للحصول على دعم أو تقديم ملاحظات.',
                            url: 'shishtawyhima@gmail.com',
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),

                          // الاتصال الهاتفي
                          const ContactItem(
                            icon: Icons.phone_in_talk_outlined,
                            color: Color(0xFFFF9800),
                            title: 'الاتصال الهاتفي',
                            text:
                                'يمكنك الاتصال بنا مباشرة على الرقم 01098338348 يوميًا من الساعة 10 صباحًا حتى 8 مساءً.',
                            url: 'tel:+201098338348',
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),

                          const SizedBox(height: 20),

                          // فيسبوك
                          const ContactItem(
                            icon: Icons.facebook,
                            color: Color(0xFF1877F2),
                            title: 'صفحتنا على فيسبوك',
                            text:
                                'تابع أحدث الأخبار والعروض وتواصل معنا عبر فيسبوك.',
                            url:
                                'https://www.facebook.com/share/1AHY1dexwG/', // رابط صفحتك
                            bgColor: Colors.white24,
                            textColor: Colors.white,
                          ),

                          // إنستجرام
                          const ContactItem(
                            icon: Icons.camera_alt_outlined,
                            color: Color(0xFFE1306C),
                            title: 'حساب إنستجرام',
                            text:
                                'شاهد صور المنتجات ونتائج العملاء عبر حسابنا على إنستجرام.',
                            url: 'https://www.instagram.com/m.almounir/',
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
                                    'يرجى تزويدنا برقم الطلب عند التواصل لتسريع عملية المساعدة، '
                                    'وسنكون سعيدين بخدمتك في أقرب وقت ممكن.',
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

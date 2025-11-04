// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/features/policies/widget/Contact_Item.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/footer_links/footer_links.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(),
      bottomNavigationBar: const FooterLinks(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      color: Color(0xFF2A82FF),
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'خدمة الدعم الفني والتواصل',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0E1A2A),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                // طرق التواصل
                const ContactItem(
                  icon: Icons.chat_outlined,
                  color: Color(0xFF25D366),
                  title: 'واتساب الدعم الفني',
                  text: 'تواصل مباشرة مع فريق خدمة العملاء على مدار الساعة.',
                  url: 'https://wa.me/201234567890',
                ),
                const ContactItem(
                  icon: Icons.email_outlined,
                  color: Color(0xFF4285F4),
                  title: 'البريد الإلكتروني',
                  text:
                      'يمكنك مراسلتنا عبر البريد للحصول على دعم أو تقديم ملاحظات.',
                  url: 'mailto:support@lamsethareer.com',
                ),
                const ContactItem(
                  icon: Icons.phone_in_talk_outlined,
                  color: Color(0xFFFF9800),
                  title: 'الاتصال الهاتفي',
                  text: 'متاح يوميًا من الساعة 10 صباحًا حتى 8 مساءً.',
                  url: 'tel:+201234567890',
                ),

                const SizedBox(height: 36),

                // نص ختامي
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F7FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF2A82FF),
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'يرجى تزويدنا برقم الطلب عند التواصل لتسريع عملية المساعدة.',
                          style: TextStyle(
                            fontSize: 15.5,
                            height: 1.6,
                            color: Colors.black87,
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
    );
  }
}

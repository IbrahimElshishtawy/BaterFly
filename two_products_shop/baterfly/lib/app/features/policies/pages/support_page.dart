// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
                const _ContactItem(
                  icon: Icons.chat_outlined,
                  color: Color(0xFF25D366),
                  title: 'واتساب الدعم الفني',
                  text: 'تواصل مباشرة مع فريق خدمة العملاء على مدار الساعة.',
                  url: 'https://wa.me/201234567890',
                ),
                const _ContactItem(
                  icon: Icons.email_outlined,
                  color: Color(0xFF4285F4),
                  title: 'البريد الإلكتروني',
                  text:
                      'يمكنك مراسلتنا عبر البريد للحصول على دعم أو تقديم ملاحظات.',
                  url: 'mailto:support@lamsethareer.com',
                ),
                const _ContactItem(
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

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String text;
  final String url;

  const _ContactItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () =>
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0E1A2A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

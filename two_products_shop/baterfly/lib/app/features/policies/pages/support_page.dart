// support_page.dart
// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/data/models/support_models.dart';
import 'package:baterfly/app/features/policies/widget/Contact_Item.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:baterfly/app/services/supabase/content_service.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  IconData _iconForType(String type) {
    switch (type) {
      case 'whatsapp':
        return Icons.chat_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_in_talk_outlined;
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'email':
        return const Color(0xFF4285F4);
      case 'phone':
        return const Color(0xFFFF9800);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE1306C);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentService = ContentService();

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          FutureBuilder<SupportPageModel>(
            future: contentService.getSupportPage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'حدث خطأ أثناء تحميل بيانات الدعم',
                    style: const TextStyle(color: Colors.white),
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

                              const SizedBox(height: 32),

                              // عناصر التواصل من Supabase
                              ...data.contacts.map(
                                (c) => ContactItem(
                                  icon: _iconForType(c.type),
                                  color: _colorForType(c.type),
                                  title: c.title,
                                  text: c.body,
                                  url: c.url,
                                  bgColor: Colors.white24,
                                  textColor: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 36),

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

                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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

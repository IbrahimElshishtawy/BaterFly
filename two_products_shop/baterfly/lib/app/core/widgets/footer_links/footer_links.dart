// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'footer_desktop_columns.dart';
import 'footer_mobile_columns.dart';
import 'footer_helpers.dart';
import 'footer_icons.dart';
import 'footer_web_button.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E1A2A), Color(0xFF0B1020)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final maxW = w >= 1440
                ? 1240.0
                : w >= 1280
                ? 1140.0
                : 1100.0;
            final hpad = w >= 1024
                ? 28.0
                : w >= 768
                ? 24.0
                : 16.0;
            final isWide = w >= 900;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hpad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.06),
                      ),
                      SizedBox(height: isWide ? 22 : 16),

                      // الأعمدة
                      isWide
                          ? const FooterDesktopColumns()
                          : const FooterMobileColumns(),

                      const SizedBox(height: 18),
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.06),
                      ),
                      const SizedBox(height: 12),

                      // الشريط السفلي
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          const FooterIconLink(
                            url: 'https://facebook.com',
                            icon: Icons.facebook,
                          ),
                          const FooterIconLink(
                            url: 'https://instagram.com',
                            icon: Icons.camera_alt_outlined,
                          ),
                          const FooterIconLink(
                            url: 'https://wa.me/201234567890',
                            icon: Icons.chat_outlined,
                          ),

                          Container(
                            width: 1,
                            height: 18,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.white.withOpacity(0.10),
                          ),

                          FooterWebButton(
                            label: 'دخول الأدمن',
                            icon: Icons.admin_panel_settings_outlined,
                            onTap: () =>
                                Navigator.pushNamed(context, '/admin/login'),
                          ),

                          Container(
                            width: 1,
                            height: 18,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.white.withOpacity(0.10),
                          ),

                          Text(
                            '© 2025 لمسة حرير',
                            style: t.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.72),
                              letterSpacing: .1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: Colors.white.withOpacity(0.9),
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00897B), Color(0xFF004D40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // روابط السياسات
          Wrap(
            spacing: 18,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _link(
                'سياسة الاستبدال والاسترجاع',
                'https://example.com/returns',
                style,
              ),
              _link('سياسة الشحن', 'https://example.com/shipping', style),
              _link('الدعم الفني', 'https://wa.me/201234567890', style),
            ],
          ),

          const SizedBox(height: 14),

          // أيقونات التواصل
          Wrap(
            spacing: 14,
            alignment: WrapAlignment.center,
            children: [
              _icon('https://facebook.com', Icons.facebook),
              _icon('https://instagram.com', Icons.camera_alt_outlined),
              _icon('https://wa.me/201234567890', Icons.chat_outlined),
            ],
          ),

          const SizedBox(height: 20),

          // زر الأدمن
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/admin'),
            icon: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.white,
            ),
            label: const Text('لوحة الأدمن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text('© 2025 لمسة حرير', style: style),
        ],
      ),
    );
  }

  Widget _link(String text, String url, TextStyle? style) => InkWell(
    onTap: () =>
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    child: Text(text, style: style),
  );

  Widget _icon(String url, IconData icon) => InkWell(
    onTap: () =>
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    child: Icon(icon, size: 26, color: Colors.white),
  );
}

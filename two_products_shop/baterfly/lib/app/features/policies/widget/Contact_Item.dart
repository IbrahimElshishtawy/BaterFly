// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String text;
  final String url;

  const ContactItem({
    super.key,
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white24, // كارد شفاف
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000), // ظل خفيف
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2), // خلفية الايقونة شفافه
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white, // النص أبيض
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 15.5,
                        height: 1.6,
                        color: Colors.white70, // أبيض خفيف للنص الثاني
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

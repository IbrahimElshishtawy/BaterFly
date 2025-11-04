// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';

class PolicyItem extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const PolicyItem({
    super.key,
    required this.number,
    required this.title,
    required this.text,
    required Color textColor,
    required Color bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.0), // شفافة بالكامل
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24), // حد أبيض شفاف
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000), // ظل خفيف
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.blueAccent, // رقم الكارد أزرق
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white, // العنوان أبيض
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.6,
                      color: Colors.white, // النص أبيض
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

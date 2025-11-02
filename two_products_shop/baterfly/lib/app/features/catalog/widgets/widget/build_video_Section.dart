// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baterfly/app/core/widgets/product_video_widget.dart';

Widget buildVideoSection(BoxConstraints constraints) {
  final videos = [
    {'url': 'assets/video/video_1.mp4', 'label': 'تجربة العملاء ❤️'},
    {'url': 'assets/video/video_2.mp4', 'label': 'مراجعة المنتج 🔥'},
    {'url': 'assets/video/video_3.mp4', 'label': 'آراء المستخدمين 🌟'},
  ];

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF0A0A0A), Color(0xFF151515)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Center(
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth > 900;

          return Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: videos.map((v) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: isWide ? c.maxWidth / 3.3 : c.maxWidth * 0.9,
                child: buildVideoCard(v['url']!, v['label']!),
              );
            }).toList(),
          );
        },
      ),
    ),
  );
}

Widget buildVideoCard(String videoUrl, String label) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        // ممكن تفتح الفيديو في شاشة كاملة هنا لاحقًا
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // خلفية الفيديو
            Positioned.fill(child: ProductVideoWidget(videoUrl: videoUrl)),

            // Gradient خفيف من أسفل
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // النص أسفل الفيديو
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

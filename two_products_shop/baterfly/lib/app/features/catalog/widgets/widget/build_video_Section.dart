// ignore_for_file: deprecated_member_use

// 🎞️ قسم الفيديوهات في المنتصف بخلفية مميزة
import 'package:baterfly/app/core/widgets/product_video_widget.dart';
import 'package:flutter/material.dart';

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
        colors: [Color(0xFF101010), Color(0xFF1F1F1F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Center(
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth > 900;

          return isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: videos.map((v) {
                    return Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: buildVideoCard(v['url']!, v['label']!),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: videos.map((v) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: buildVideoCard(v['url']!, v['label']!),
                      ),
                    );
                  }).toList(),
                );
        },
      ),
    ),
  );
}

Widget buildVideoCard(String videoUrl, String label) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        // تشغيل الفيديو فعليًا
        ProductVideoWidget(videoUrl: videoUrl),

        // طبقة غامقة خفيفة
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // العنوان في منتصف الفيديو
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/widgets/product_video_widget.dart';

class BuildVideoSection extends StatelessWidget {
  const BuildVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1000
        ? 4
        : width > 600
        ? 2
        : 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'تجارب عملائنا مع منتجاتنا',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 16 / 9,
                ),
                itemBuilder: (context, index) {
                  final videos = [
                    {
                      'url': 'assets/video/video_1.mp4',
                      'title': 'تجربت سيرراميد بترفلاي الشعرلي مع الشعر ',
                    },
                    {
                      'url': 'assets/video/video_2.mp4',
                      'title': 'نتيجة سيراميد بترفلاي مع الشعر المتهالك ',
                    },
                    {
                      'url': 'assets/video/video_3.mp4',
                      'title': ' نتيجة سيراميد بترفلاي مع الشر النبيتي ',
                    },
                    {'url': 'assets/video/video_4.mp4', 'title': ' '},
                  ];

                  final video = videos[index];
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ProductVideoWidget(videoUrl: video['url']!),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          video['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

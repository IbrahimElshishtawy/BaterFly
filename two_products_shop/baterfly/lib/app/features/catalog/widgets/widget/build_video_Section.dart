import 'package:flutter/material.dart';
import '../../../../core/widgets/product_video_widget.dart';

class BuildVideoSection extends StatelessWidget {
  const BuildVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '🎬 اكتشف أحدث الفيديوهات والعروض',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: width > 1000
                    ? 3
                    : width > 600
                    ? 2
                    : 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 16 / 9,
                children: const [
                  ProductVideoWidget(videoUrl: 'assets/videos/vid1.mp4'),
                  ProductVideoWidget(videoUrl: 'assets/videos/vid2.mp4'),
                  ProductVideoWidget(videoUrl: 'assets/videos/vid3.mp4'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

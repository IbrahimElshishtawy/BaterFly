// ignore_for_file: file_names, deprecated_member_use

import 'package:baterfly/app/features/catalog/widgets/widget/social_video_opener.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/product_video_widget.dart';

class BuildVideoSection extends StatefulWidget {
  const BuildVideoSection({super.key});

  @override
  State<BuildVideoSection> createState() => _BuildVideoSectionState();
}

class _BuildVideoSectionState extends State<BuildVideoSection> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchVideos() async {
    final response = await supabase
        .from('videos')
        .select('id, video_url, title')
        .order('id', ascending: true);

    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  }

  bool _isSocialLink(String url) {
    final lower = url.toLowerCase();
    return lower.contains('facebook.com') ||
        lower.contains('fb.watch') ||
        lower.contains('instagram.com') ||
        lower.contains('instagram');
  }

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

              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchVideos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'حدث خطأ أثناء تحميل الفيديوهات',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final videos = snapshot.data ?? [];

                  if (videos.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'لا توجد فيديوهات حالياً',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: videos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 16 / 9,
                    ),
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final url = video['video_url'] as String;
                      final title = video['title'] as String? ?? '';

                      final isSocial = _isSocialLink(url);

                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: isSocial
                                ? SocialVideoOpener(url: url, title: title)
                                : ProductVideoWidget(videoUrl: url),
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
                              title,
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

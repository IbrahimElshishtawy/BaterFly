// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialVideoOpener extends StatelessWidget {
  final String url;
  final String title;

  const SocialVideoOpener({super.key, required this.url, required this.title});

  bool get _isFacebook {
    final lower = url.toLowerCase();
    return lower.contains('facebook.com') || lower.contains('fb.watch');
  }

  bool get _isInstagram {
    final lower = url.toLowerCase();
    return lower.contains('instagram.com') || lower.contains('instagram');
  }

  String get _platformName {
    if (_isFacebook) return 'فيسبوك';
    if (_isInstagram) return 'إنستجرام';
    return 'السوشيال ميديا';
  }

  IconData get _platformIcon {
    if (_isFacebook) return Icons.facebook;
    if (_isInstagram) return Icons.camera_alt_rounded;
    return Icons.play_circle_fill;
  }

  Color get _mainColor {
    if (_isFacebook) return const Color(0xFF1877F2); // أزرق فيسبوك
    if (_isInstagram) return const Color(0xFFE1306C); // لون إنستجرام
    return Colors.white;
  }

  Future<void> _openVideo() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // يمكنك إضافة SnackBar أو أي handling هنا لو حابب
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openVideo,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: _isInstagram
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFEDA77),
                    Color(0xFFF58529),
                    Color(0xFFDD2A7B),
                    Color(0xFF8134AF),
                    Color(0xFF515BD4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: Stack(
          children: [
            // الآيكون في المنتصف
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: Icon(_platformIcon, size: 48, color: _mainColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'اضغط لعرض الفيديو على $_platformName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // العنوان في الأعلى (اختياري)
            if (title.isNotEmpty)
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

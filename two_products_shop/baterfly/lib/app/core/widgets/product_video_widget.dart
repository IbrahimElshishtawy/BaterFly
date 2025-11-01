// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProductVideoWidget extends StatefulWidget {
  final String videoUrl;
  // مش محتاجين نحدد نسبة ثابتة هنا كمان
  const ProductVideoWidget({Key? key, required this.videoUrl})
    : super(key: key);

  @override
  State<ProductVideoWidget> createState() => _ProductVideoWidgetState();
}

class _ProductVideoWidgetState extends State<ProductVideoWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  // 1. متغير جديد عشان نخزن فيه نسبة العرض للارتفاع الحقيقية للفيديو
  double? _videoAspectRatio;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        // 2. لما الفيديو يخلص التحميل، بنحسب النسبة من أبعاده الحقيقية
        if (_controller.value.size.width > 0 &&
            _controller.value.size.height > 0) {
          _videoAspectRatio =
              _controller.value.size.width / _controller.value.size.height;
        }

        setState(() {
          _isInitialized = true;
        });
        _controller.addListener(_videoListener);
      });
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // لو الفيديو مزلش اتحمل أو نسبة العرض للارتفاع مش معروفة
    if (!_isInitialized || _videoAspectRatio == null) {
      return Container(
        width: double.infinity, // اخد العرض الكامل
        height: 200,
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 3. بنستخدم النسبة اللي حسبناها من الفيديو نفسه
    return AspectRatio(
      aspectRatio: _videoAspectRatio!,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          // زر التشغيل/الإيقاف المخصص
          if (!_isPlaying)
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          // شريط التقدم
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.blue,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.lightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: use_super_parameters, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProductVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? overlayText;

  const ProductVideoWidget({Key? key, required this.videoUrl, this.overlayText})
    : super(key: key);

  @override
  State<ProductVideoWidget> createState() => _ProductVideoWidgetState();
}

class _ProductVideoWidgetState extends State<ProductVideoWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  double? _videoAspectRatio;

  @override
  void initState() {
    super.initState();

    // تشغيل الفيديو من الإنترنت
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (_controller.value.size.width > 0 &&
            _controller.value.size.height > 0) {
          _videoAspectRatio =
              _controller.value.size.width / _controller.value.size.height;
        }

        setState(() {
          _isInitialized = true;
        });

        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();

        _isPlaying = true;
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
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _videoAspectRatio == null) {
      return Container(
        color: Colors.black12,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isInitialized ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: AspectRatio(
              aspectRatio: _videoAspectRatio!,
              child: VideoPlayer(_controller),
            ),
          ),
          if (widget.overlayText != null && widget.overlayText!.isNotEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Text(
                widget.overlayText!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
            ),

          // زر تشغيل عند الإيقاف
          if (!_isPlaying)
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(color: Colors.transparent),
            ),

          // شريط التقدم
          Positioned(
            bottom: 8,
            left: 10,
            right: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: EdgeInsets.zero,
                colors: const VideoProgressColors(
                  playedColor: Color.fromARGB(255, 68, 74, 255),
                  backgroundColor: Colors.white24,
                  bufferedColor: Colors.lightBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

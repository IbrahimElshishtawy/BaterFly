// lib/core/models/video_model.dart

class VideoModel {
  final int id;
  final String videoUrl;
  final String title;

  VideoModel({required this.id, required this.videoUrl, required this.title});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as int,
      videoUrl: json['video_url'] as String,
      title: json['title'] as String,
    );
  }
}

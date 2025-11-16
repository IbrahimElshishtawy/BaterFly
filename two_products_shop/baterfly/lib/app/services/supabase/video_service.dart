// lib/core/services/video_service.dart
// ignore_for_file: unnecessary_cast

import 'package:baterfly/app/data/models/video_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<List<VideoModel>> getVideos() async {
    final response = await _client
        .from('videos')
        .select('id, video_url, title')
        .order('id', ascending: true);

    final List<VideoModel> videos = (response as List)
        .map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return videos;
  }

  static Future<VideoModel> addVideo({
    required String videoUrl,
    required String title,
  }) async {
    final response = await _client
        .from('videos')
        .insert({'video_url': videoUrl, 'title': title})
        .select()
        .single();

    return VideoModel.fromJson(response as Map<String, dynamic>);
  }

  static Future<VideoModel> updateVideo({
    required int id,
    String? videoUrl,
    String? title,
  }) async {
    final Map<String, dynamic> dataToUpdate = {};

    if (videoUrl != null) dataToUpdate['video_url'] = videoUrl;
    if (title != null) dataToUpdate['title'] = title;

    final response = await _client
        .from('videos')
        .update(dataToUpdate)
        .eq('id', id)
        .select()
        .single();

    return VideoModel.fromJson(response as Map<String, dynamic>);
  }

  static Future<void> deleteVideo(int id) async {
    await _client.from('videos').delete().eq('id', id);
  }
}

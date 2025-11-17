// lib/core/services/video_service.dart

import 'package:baterfly/app/data/models/video_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoService {
  VideoService._();

  static final SupabaseClient _client = Supabase.instance.client;

  /// جلب كل الفيديوهات (أحدثها أولاً)
  static Future<List<VideoModel>> fetchVideos() async {
    final response = await _client
        .from('videos')
        .select('id, video_url, title, created_at')
        .order('created_at', ascending: false);

    final List data = response as List;
    return data
        .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// إضافة فيديو جديد
  static Future<void> addVideo({
    required String videoUrl,
    required String title,
  }) async {
    await _client.from('videos').insert({
      'video_url': videoUrl,
      'title': title,
    });
  }

  /// حذف فيديو
  static Future<void> deleteVideo(int id) async {
    await _client.from('videos').delete().eq('id', id);
  }
}

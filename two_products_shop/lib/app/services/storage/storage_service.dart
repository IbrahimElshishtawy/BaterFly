import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class StorageService {
  final SupabaseClient _db = Supa.client;

  Future<String> uploadProductImage(File file, String fileName) async {
    final path = 'product-images/$fileName';
    final res = await _db.storage.from('product-images').upload(path, file);
    if (res.isEmpty) {
      throw Exception('Upload failed');
    }
    return _db.storage.from('product-images').getPublicUrl(path);
  }

  Future<void> deleteFile(String path) async {
    await _db.storage.from('product-images').remove([path]);
  }
}

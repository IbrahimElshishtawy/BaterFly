import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_service.dart';

class StorageService {
  final SupabaseClient _sb = Supa.client;

  Future<String?> uploadProductImage(String path, String fileName) async {
    final file = await _sb.storage
        .from('product-images')
        .upload(fileName, path as File);
    final publicUrl = _sb.storage.from('product-images').getPublicUrl(fileName);
    return publicUrl;
  }
}

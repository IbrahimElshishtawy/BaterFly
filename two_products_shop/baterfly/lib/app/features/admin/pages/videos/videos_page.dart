// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/data/models/video_model.dart';
import 'package:baterfly/app/services/supabase/video_service.dart';
import 'package:flutter/material.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final _formKey = GlobalKey<FormState>();
  final _videoUrlController = TextEditingController();
  final _titleController = TextEditingController();

  bool _isSaving = false;
  bool _isLoadingList = false;
  String? _message;

  List<VideoModel> _videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void dispose() {
    _videoUrlController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    if (!mounted) return;

    setState(() {
      _isLoadingList = true;
      _message = null;
    });

    try {
      final videos = await VideoService.fetchVideos();

      if (!mounted) return;

      setState(() {
        _videos = videos;
        _isLoadingList = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingList = false;
        _message = "حدث خطأ أثناء تحميل قائمة الفيديوهات: $e";
      });
    }
  }

  Future<void> _addVideo() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() {
      _isSaving = true;
      _message = null;
    });

    try {
      final videoUrl = _videoUrlController.text.trim();
      final title = _titleController.text.trim();

      await VideoService.addVideo(videoUrl: videoUrl, title: title);

      if (!mounted) return;

      _videoUrlController.clear();
      _titleController.clear();

      setState(() {
        _message = "تم إضافة الفيديو بنجاح";
        _isSaving = false;
      });

      await _loadVideos();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _message = "حدث خطأ أثناء إضافة الفيديو: $e";
      });
    }
  }

  Future<void> _deleteVideo(VideoModel video) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("حذف الفيديو"),
            content: Text(
              "هل أنت متأكد أنك تريد حذف الفيديو:\n${video.title.isEmpty ? '(بدون عنوان)' : video.title} ؟",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("حذف", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );

    if (confirm != true) return;

    try {
      await VideoService.deleteVideo(video.id);

      if (!mounted) return;

      setState(() {
        _videos.removeWhere((v) => v.id == video.id);
        _message = "تم حذف الفيديو بنجاح";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _message = "حدث خطأ أثناء حذف الفيديو: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh: _loadVideos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ================== فورم الإضافة ==================
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "إضافة فيديو جديد",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),

                              TextFormField(
                                controller: _videoUrlController,
                                decoration: const InputDecoration(
                                  labelText: "رابط الفيديو (Video URL)",
                                  hintText: "https://.../video.mp4",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.url,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "من فضلك أدخل رابط الفيديو";
                                  }
                                  if (!value.startsWith("http")) {
                                    return "من فضلك أدخل رابط صحيح يبدأ بـ http";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  labelText: "عنوان / نص الفيديو",
                                  hintText:
                                      "مثال: تجربة سيراميد بترفلاي مع الشعر...",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 2,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "من فضلك أدخل عنوان الفيديو";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              if (_message != null) ...[
                                Text(
                                  _message!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _message!.startsWith("تم")
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: _isSaving ? null : _addVideo,
                                  icon: _isSaving
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label: Text(
                                    _isSaving ? "جاري الحفظ..." : "حفظ الفيديو",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "ملاحظة: تأكد أن رابط الفيديو مباشر (mp4 أو stream) ويعمل بشكل صحيح.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================== قائمة الفيديوهات ==================
                    Text(
                      "الفيديوهات المضافة",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_isLoadingList)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_videos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          "لا توجد فيديوهات حالياً.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _videos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final video = _videos[index];

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                video.title.isEmpty
                                    ? "(بدون عنوان)"
                                    : video.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                video.videoUrl,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              leading: const Icon(
                                Icons.video_library,
                                color: Colors.blueAccent,
                              ),
                              trailing: IconButton(
                                tooltip: "حذف الفيديو",
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteVideo(video),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

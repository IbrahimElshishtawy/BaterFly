// features/admin/content/support_editor.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baterfly/app/services/supabase/content_service.dart';
import 'package:baterfly/app/data/models/support_models.dart';

class SupportEditor extends StatefulWidget {
  const SupportEditor({super.key});

  @override
  State<SupportEditor> createState() => _SupportEditorState();
}

class _SupportEditorState extends State<SupportEditor> {
  final _service = ContentService();

  late Future<SupportPageModel> _future;
  final _introController = TextEditingController();
  final _noteController = TextEditingController();

  bool _initialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _future = _service.getSupportPage();
  }

  @override
  void dispose() {
    _introController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _initialized = false;
      _future = _service.getSupportPage();
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final model = SupportPageModel(
        introText: _introController.text.trim(),
        noteText: _noteController.text.trim(),
        contacts: const [],
      );

      await _service.updateSupportPage(model);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ بيانات صفحة الدعم بنجاح'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الحفظ: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<SupportPageModel>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_initialized) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent),
                const SizedBox(height: 8),
                const Text(
                  'خطأ في تحميل بيانات صفحة الدعم',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _reload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData && !_initialized) {
          final data = snapshot.data!;
          _introController.text = data.introText ?? '';
          _noteController.text = data.noteText ?? '';
          _initialized = true;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                elevation: 3,
                shadowColor: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.headset_mic_outlined,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'صفحة الدعم الفني والتواصل',
                                  textDirection: TextDirection.rtl,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'تحكم في النص الترحيبي ونص التعليمات الإضافية الظاهرة أسفل وسائل التواصل.',
                                  textDirection: TextDirection.rtl,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      TextField(
                        controller: _introController,
                        textDirection: TextDirection.rtl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'النص الترحيبي / مقدمة صفحة الدعم',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _noteController,
                        textDirection: TextDirection.rtl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'نص ختامي / تعليمات إضافية',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: _saving ? null : _reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة التحميل من السيرفر'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: _saving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(_saving ? 'جاري الحفظ...' : 'حفظ'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

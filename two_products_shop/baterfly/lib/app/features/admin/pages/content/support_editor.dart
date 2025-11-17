// features/admin/content/support_editor.dart
// ignore_for_file: deprecated_member_use, unnecessary_underscores

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

  List<SupportContactModel> _contacts = [];

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

  Future<void> _saveTexts() async {
    setState(() => _saving = true);
    try {
      final model = SupportPageModel(
        introText: _introController.text.trim(),
        noteText: _noteController.text.trim(),
        contacts: _contacts,
      );

      await _service.updateSupportPage(model);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ نصوص صفحة الدعم بنجاح'),
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

  // ===== قنوات التواصل =====

  IconData _iconForType(String type) {
    switch (type) {
      case 'whatsapp':
        return Icons.chat_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_in_talk_outlined;
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt_outlined;
      default:
        return Icons.link;
    }
  }

  Future<void> _addOrEditContact({SupportContactModel? contact}) async {
    final isEdit = contact != null;

    final titleCtrl = TextEditingController(text: contact?.title ?? '');
    final bodyCtrl = TextEditingController(text: contact?.body ?? '');
    final urlCtrl = TextEditingController(text: contact?.url ?? '');
    String typeValue = contact?.type ?? 'whatsapp';

    final result = await showDialog<SupportContactModel>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEdit ? 'تعديل قناة تواصل' : 'إضافة قناة تواصل'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: titleCtrl,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    labelText: 'عنوان القناة (مثال: واتساب الدعم الفني)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: bodyCtrl,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'وصف مختصر'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: urlCtrl,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'الرابط / رقم الهاتف',
                    hintText: 'https://... أو tel:+2010... أو mailto:...',
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: typeValue,
                  decoration: const InputDecoration(labelText: 'نوع القناة'),
                  items: const [
                    DropdownMenuItem(value: 'whatsapp', child: Text('واتساب')),
                    DropdownMenuItem(
                      value: 'email',
                      child: Text('بريد إلكتروني'),
                    ),
                    DropdownMenuItem(
                      value: 'phone',
                      child: Text('اتصال هاتفي'),
                    ),
                    DropdownMenuItem(value: 'facebook', child: Text('فيسبوك')),
                    DropdownMenuItem(
                      value: 'instagram',
                      child: Text('إنستجرام'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      typeValue = val;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty ||
                    bodyCtrl.text.trim().isEmpty ||
                    urlCtrl.text.trim().isEmpty) {
                  return;
                }

                final updated = SupportContactModel(
                  id: contact?.id,
                  title: titleCtrl.text.trim(),
                  body: bodyCtrl.text.trim(),
                  url: urlCtrl.text.trim(),
                  type: typeValue,
                );

                Navigator.of(ctx).pop(updated);
              },
              child: Text(isEdit ? 'حفظ' : 'إضافة'),
            ),
          ],
        );
      },
    );

    if (result == null) return;

    if (isEdit) {
      final updated = await _service.updateSupportContact(result);
      setState(() {
        final index = _contacts.indexWhere((c) => c.id == updated.id);
        if (index != -1) _contacts[index] = updated;
      });
    } else {
      final created = await _service.createSupportContact(
        title: result.title,
        body: result.body,
        url: result.url,
        type: result.type,
        sortOrder: _contacts.length + 1,
      );
      setState(() => _contacts.add(created));
    }
  }

  Future<void> _deleteContact(SupportContactModel contact) async {
    if (contact.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف قناة تواصل'),
        content: const Text('هل أنت متأكد من حذف هذه القناة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _service.deleteSupportContact(contact.id!);
    setState(() {
      _contacts.removeWhere((c) => c.id == contact.id);
    });
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
          _contacts = List<SupportContactModel>.from(data.contacts);
          _initialized = true;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Card(
                color: const Color(0xFFFFF1F1), // قريب من الوردي في الصورة
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
                      // هيدر
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.08),
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
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // النصوص
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
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                          fillColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // قنوات التواصل
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قنوات التواصل (واتساب، إيميل، فيسبوك...)',
                            textDirection: TextDirection.rtl,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _addOrEditContact(),
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة قناة'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_contacts.isEmpty)
                        const Text(
                          'لا توجد قنوات تواصل بعد. اضغط "إضافة قناة" لإضافة واتساب أو إيميل أو غيره.',
                          textDirection: TextDirection.rtl,
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _contacts.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final c = _contacts[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(_iconForType(c.type)),
                              title: Text(
                                c.title,
                                textDirection: TextDirection.rtl,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    c.body,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    c.url,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'تعديل',
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _addOrEditContact(contact: c),
                                  ),
                                  IconButton(
                                    tooltip: 'حذف',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _deleteContact(c),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 20),

                      // أزرار النصوص
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: _saving ? null : _reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة التحميل من السيرفر'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _saving ? null : _saveTexts,
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

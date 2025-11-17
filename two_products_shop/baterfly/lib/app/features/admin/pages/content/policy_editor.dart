// features/admin/content/policy_editor.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baterfly/app/services/supabase/content_service.dart';
import 'package:baterfly/app/data/models/policy_models.dart';

class PolicyEditor extends StatefulWidget {
  final String slug; // shipping / returns
  final String label;

  const PolicyEditor({super.key, required this.slug, required this.label});

  @override
  State<PolicyEditor> createState() => _PolicyEditorState();
}

class _PolicyEditorState extends State<PolicyEditor> {
  final _service = ContentService();

  late Future<PolicyPageModel> _future;
  final _mainTitleController = TextEditingController();
  final _introController = TextEditingController();
  final _noteController = TextEditingController();

  bool _initialized = false;
  bool _saving = false;
  List<PolicyItemModel> _items = [];

  @override
  void initState() {
    super.initState();
    _future = _service.getPolicyPage(widget.slug);
  }

  @override
  void dispose() {
    _mainTitleController.dispose();
    _introController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _initialized = false;
      _future = _service.getPolicyPage(widget.slug);
    });
  }

  Future<void> _savePage() async {
    setState(() => _saving = true);
    try {
      final model = PolicyPageModel(
        slug: widget.slug,
        mainTitle: _mainTitleController.text.trim(),
        introText: _introController.text.trim(),
        noteText: _noteController.text.trim(),
        items: _items,
      );

      await _service.updatePolicyPage(model);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ بيانات الصفحة بنجاح'),
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

  Future<void> _addOrEditItem({PolicyItemModel? item}) async {
    final isEdit = item != null;

    final numberCtrl = TextEditingController(text: item?.number ?? '');
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final bodyCtrl = TextEditingController(text: item?.body ?? '');

    final result = await showDialog<PolicyItemModel>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEdit ? 'تعديل بند' : 'إضافة بند جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: numberCtrl,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    labelText: 'رقم البند (اختياري)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleCtrl,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(labelText: 'عنوان البند'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: bodyCtrl,
                  textDirection: TextDirection.rtl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'نص البند'),
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
                    bodyCtrl.text.trim().isEmpty) {
                  return;
                }
                final updated = PolicyItemModel(
                  id: item?.id,
                  number: numberCtrl.text.trim().isEmpty
                      ? null
                      : numberCtrl.text.trim(),
                  title: titleCtrl.text.trim(),
                  body: bodyCtrl.text.trim(),
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
      // تعديل في Supabase
      final updatedFromServer = await _service.updatePolicyItem(result);
      setState(() {
        final index = _items.indexWhere((it) => it.id == updatedFromServer.id);
        if (index != -1) {
          _items[index] = updatedFromServer;
        }
      });
    } else {
      // إضافة جديدة
      final created = await _service.createPolicyItem(
        pageSlug: widget.slug,
        number: result.number,
        title: result.title,
        body: result.body,
        sortOrder: _items.length + 1,
      );
      setState(() {
        _items.add(created);
      });
    }
  }

  Future<void> _deleteItem(PolicyItemModel item) async {
    if (item.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف البند'),
        content: const Text('هل أنت متأكد من حذف هذا البند؟'),
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

    await _service.deletePolicyItem(item.id!);
    setState(() {
      _items.removeWhere((it) => it.id == item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<PolicyPageModel>(
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
                  'خطأ في تحميل بيانات الصفحة',
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
          _mainTitleController.text = data.mainTitle;
          _introController.text = data.introText ?? '';
          _noteController.text = data.noteText ?? '';
          _items = List<PolicyItemModel>.from(data.items);
          _initialized = true;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
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
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              widget.slug == 'shipping'
                                  ? Icons.local_shipping_outlined
                                  : Icons.assignment_return_outlined,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.label,
                                  textDirection: TextDirection.rtl,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'تعديل العنوان والنص التمهيدي والملاحظة الختامية والبنود التفصيلية لهذه الصفحة.',
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

                      // حقول العنوان/المقدمة/الملاحظة
                      TextField(
                        controller: _mainTitleController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: 'العنوان الرئيسي في الصفحة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _introController,
                        textDirection: TextDirection.rtl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'النص التمهيدي (الفقرة الأولى)',
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
                          labelText: 'ملاحظة ختامية / تنبيه مهم',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ===== قائمة البنود =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'البنود التفصيلية',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _addOrEditItem(),
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة بند'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_items.isEmpty)
                        const Text(
                          'لا توجد بنود بعد. اضغط على "إضافة بند" لإضافة أول بند.',
                          textDirection: TextDirection.rtl,
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${item.number ?? (index + 1)} - ${item.title}',
                                textDirection: TextDirection.rtl,
                              ),
                              subtitle: Text(
                                item.body,
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'تعديل',
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _addOrEditItem(item: item),
                                  ),
                                  IconButton(
                                    tooltip: 'حذف',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _deleteItem(item),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 20),

                      // أزرار الحفظ وإعادة التحميل
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: _saving ? null : _reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة التحميل من السيرفر'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _saving ? null : _savePage,
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

// features/admin/content/policy/policy_editor.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baterfly/app/services/supabase/content_service.dart';
import 'package:baterfly/app/data/models/policy_models.dart';

import 'widgets/policy_page_header.dart';
import 'widgets/policy_page_form.dart';
import 'widgets/policy_items_section.dart';
import 'widgets/policy_item_dialog.dart';

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
    final edited = await showPolicyItemDialog(context: context, existing: item);

    if (edited == null) return;

    if (item != null) {
      // تعديل
      final updatedFromServer = await _service.updatePolicyItem(edited);
      setState(() {
        final index = _items.indexWhere((it) => it.id == updatedFromServer.id);
        if (index != -1) {
          _items[index] = updatedFromServer;
        }
      });
    } else {
      // إضافة
      final created = await _service.createPolicyItem(
        pageSlug: widget.slug,
        number: edited.number,
        title: edited.title,
        body: edited.body,
        sortOrder: _items.length + 1,
      );
      setState(() => _items.add(created));
    }
  }

  Future<void> _deleteItem(PolicyItemModel item) async {
    if (item.id == null) return;

    final confirmed = await showDialog<bool>(
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

    if (confirmed != true) return;

    await _service.deletePolicyItem(item.id!);
    setState(() {
      _items.removeWhere((it) => it.id == item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

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
                      PolicyPageHeader(slug: widget.slug, label: widget.label),

                      const SizedBox(height: 18),

                      PolicyPageForm(
                        mainTitleController: _mainTitleController,
                        introController: _introController,
                        noteController: _noteController,
                      ),

                      const SizedBox(height: 20),

                      PolicyItemsSection(
                        items: _items,
                        onAddPressed: _addOrEditItem,
                        onEditPressed: (item) => _addOrEditItem(item: item),
                        onDeletePressed: _deleteItem,
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

// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/services/supabase/content_service.dart';
import 'package:flutter/material.dart';

import 'package:baterfly/app/data/models/policy_models.dart';
import 'package:baterfly/app/data/models/support_models.dart';

class ContentAdminPage extends StatelessWidget {
  const ContentAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===== Header =====
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.indigo,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'إدارة محتوى الصفحات الثابتة',
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'يمكنك من هنا تعديل نصوص سياسة الشحن، وسياسة الاستبدال، وصفحة الدعم الفني دون الحاجة لتحديث التطبيق.',
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
          ),

          const SizedBox(height: 4),

          // ===== Tabs =====
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const TabBar(
              isScrollable: true,
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.indigo,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'سياسة الشحن'),
                Tab(text: 'سياسة الاستبدال'),
                Tab(text: 'صفحة الدعم الفني'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Tab Views =====
          Expanded(
            child: TabBarView(
              children: [
                _PolicyEditor(slug: 'shipping', label: 'سياسة الشحن'),
                _PolicyEditor(slug: 'returns', label: 'سياسة الاستبدال'),
                const _SupportEditor(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// =============== Policy Editor (Shipping / Returns) ========
// ===========================================================

class _PolicyEditor extends StatefulWidget {
  final String slug; // 'shipping' or 'returns'
  final String label; // للعرض في الهيدر داخل الكارد

  const _PolicyEditor({required this.slug, required this.label});

  @override
  State<_PolicyEditor> createState() => _PolicyEditorState();
}

class _PolicyEditorState extends State<_PolicyEditor> {
  final _service = ContentService();

  late Future<PolicyPageModel> _future;
  final _mainTitleController = TextEditingController();
  final _introController = TextEditingController();
  final _noteController = TextEditingController();

  bool _initialized = false;
  bool _saving = false;

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

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final model = PolicyPageModel(
        slug: widget.slug,
        mainTitle: _mainTitleController.text.trim(),
        introText: _introController.text.trim(),
        noteText: _noteController.text.trim(),
        items: const [], // البنود لا يتم تعديلها من هذه الشاشة
      );

      await _service.updatePolicyPage(model);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التعديلات بنجاح'),
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
      if (mounted) {
        setState(() => _saving = false);
      }
    }
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
                Text(
                  'خطأ في تحميل بيانات ${''}',
                  style: const TextStyle(color: Colors.red),
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
                      // Header inside card
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
                                  'تعديل العنوان والنص التمهيدي والملاحظة الختامية لهذه الصفحة.',
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

                      // Form fields
                      TextField(
                        controller: _mainTitleController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          labelText: 'العنوان الرئيسي في الصفحة',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
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
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'النص التمهيدي (الفقرة الأولى)',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          hintText: 'اكتب مقدمة توضح سياسة الشحن/الاستبدال...',
                          hintTextDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _noteController,
                        textDirection: TextDirection.rtl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'ملاحظة ختامية / تنبيه مهم',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          hintText:
                              'مثال: يرجى التأكد من عنوان التوصيل ورقم الهاتف...',
                          hintTextDirection: TextDirection.rtl,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Actions row
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

// ===========================================================
// ==================== Support Editor =======================
// ===========================================================

class _SupportEditor extends StatefulWidget {
  const _SupportEditor();

  @override
  State<_SupportEditor> createState() => _SupportEditorState();
}

class _SupportEditorState extends State<_SupportEditor> {
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
        contacts:
            const [], // إدارة قنوات التواصل يمكن إضافتها لاحقًا في شاشة أخرى
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
      if (mounted) {
        setState(() => _saving = false);
      }
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
                Text(
                  'خطأ في تحميل بيانات صفحة الدعم',
                  style: const TextStyle(color: Colors.red),
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
                      // Header
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
                          hintText:
                              'مثال: يسعدنا دائمًا تواصلك معنا لأي استفسار أو ملاحظة...',
                          hintTextDirection: TextDirection.rtl,
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
                          hintText:
                              'مثال: يرجى تزويدنا برقم الطلب عند التواصل لتسريع عملية المساعدة...',
                          hintTextDirection: TextDirection.rtl,
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

// lib/app/features/admin/pages/reviews_page.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../features/product/widgets/gradient_bg.dart';
import '../../../services/supabase/supabase_service.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with SingleTickerProviderStateMixin {
  final _sb = Supa.client;
  late Future<List<Map<String, dynamic>>> _f;
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  )..forward();

  String _filter = 'all'; // all | approved | pending | rejected
  String _q = '';

  @override
  void initState() {
    super.initState();
    _f = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final res = await _sb
        .from('product_reviews')
        .select()
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> _approve(int id) async {
    await _sb
        .from('product_reviews')
        .update({'status': 'approved'})
        .eq('id', id);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم اعتماد التقييم')));
    setState(() => _f = _load());
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent; // pending أو غير معروف
    }
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> all) {
    Iterable<Map<String, dynamic>> x = all;
    if (_filter != 'all') {
      x = x.where((r) => (r['status'] ?? 'pending') == _filter);
    }
    if (_q.isNotEmpty) {
      final ql = _q.toLowerCase();
      x = x.where((r) {
        final name = (r['full_name'] ?? '').toString().toLowerCase();
        final cmt = (r['comment'] ?? '').toString().toLowerCase();
        return name.contains(ql) || cmt.contains(ql);
      });
    }
    return x.toList();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _f,
            builder: (context, s) {
              if (s.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final all = s.data ?? const [];
              final reviews = _applyFilters(all);

              return Column(
                children: [
                  // شريط أدوات أعلى القائمة
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        // بحث
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _q = v.trim()),
                            decoration: InputDecoration(
                              hintText: 'بحث باسم العميل أو التعليق',
                              prefixIcon: const Icon(Icons.search),
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.95),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // فلتر الحالة
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: DropdownButton<String>(
                              value: _filter,
                              items: const [
                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text('الكل'),
                                ),
                                DropdownMenuItem(
                                  value: 'approved',
                                  child: Text('المعتمدة'),
                                ),
                                DropdownMenuItem(
                                  value: 'pending',
                                  child: Text('قيد المراجعة'),
                                ),
                                DropdownMenuItem(
                                  value: 'rejected',
                                  child: Text('مرفوضة'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _filter = v ?? 'all'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (reviews.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'لا توجد تقييمات مطابقة',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: reviews.length,
                        itemBuilder: (_, i) {
                          final r = reviews[i];
                          final name = r['full_name'] ?? '—';
                          final comment = r['comment'] ?? '';
                          final status = (r['status'] ?? 'pending').toString();
                          final rating = (r['rating'] as num?)?.toDouble() ?? 0;
                          final createdAt = (r['created_at'] ?? '').toString();

                          return FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _ac,
                              curve: Interval(
                                i / (reviews.length + 1),
                                1,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white.withOpacity(0.96),
                                border: Border.all(color: Colors.black12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // حرف أول كأفاتار
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.teal.withOpacity(
                                      0.15,
                                    ),
                                    child: Text(
                                      (name.toString().isNotEmpty
                                          ? name.toString()[0]
                                          : '?'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // نصوص
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                name.toString(),
                                                style: const TextStyle(
                                                  fontSize: 15.5,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            // شارة الحالة
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _statusColor(
                                                  status,
                                                ).withOpacity(0.12),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: _statusColor(
                                                    status,
                                                  ).withOpacity(0.28),
                                                ),
                                              ),
                                              child: Text(
                                                status == 'approved'
                                                    ? 'معتمد'
                                                    : status == 'rejected'
                                                    ? 'مرفوض'
                                                    : 'قيد المراجعة',
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: _statusColor(status),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        // نجوم التقييم
                                        Row(
                                          children: List.generate(
                                            5,
                                            (idx) => Icon(
                                              idx < rating.round()
                                                  ? Icons.star_rounded
                                                  : Icons.star_border_rounded,
                                              size: 18,
                                              color: const Color(0xFFFFC107),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          comment.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.35,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          createdAt.split('T').first,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // أزرار
                                  if (status != 'approved')
                                    ElevatedButton.icon(
                                      onPressed: () => _approve(r['id'] as int),
                                      icon: const Icon(
                                        Icons.check_circle_outline,
                                      ),
                                      label: const Text('اعتماد'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

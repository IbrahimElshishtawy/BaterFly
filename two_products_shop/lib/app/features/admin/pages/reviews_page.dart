import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';

class AdminReviewsPage extends StatefulWidget {
  const AdminReviewsPage({super.key});

  @override
  State<AdminReviewsPage> createState() => _AdminReviewsPageState();
}

class _AdminReviewsPageState extends State<AdminReviewsPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await Supa.client
        .from(AppConstants.tblReviews)
        .select()
        .order('created_at', ascending: false);
    setState(() {
      _items = (res as List).cast<Map<String, dynamic>>();
      _loading = false;
    });
  }

  Future<void> _update(int id, String status) async {
    await Supa.client
        .from(AppConstants.tblReviews)
        .update({'status': status})
        .eq('id', id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('التقييمات')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (_, i) {
          final r = _items[i];
          return ListTile(
            title: Text(r['comment'] ?? ''),
            subtitle: Text(
              'تقييم: ${r['rating']} | منتج: ${r['product_id']} | حالة: ${r['status']}',
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _update(r['id'], 'approved'),
                  child: const Text('اعتماد'),
                ),
                TextButton(
                  onPressed: () => _update(r['id'], 'rejected'),
                  child: const Text('رفض'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

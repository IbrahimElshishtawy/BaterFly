import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_service.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final _sb = Supa.client;
  late Future<List<Map<String, dynamic>>> f;

  @override
  void initState() {
    super.initState();
    f = _load();
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
    setState(() => f = _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة التقييمات')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: f,
        builder: (c, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reviews = s.data!;
          if (reviews.isEmpty) {
            return const Center(child: Text('لا توجد تقييمات'));
          }
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (_, i) {
              final r = reviews[i];
              return ListTile(
                title: Text(r['full_name']),
                subtitle: Text(r['comment']),
                trailing: r['status'] == 'approved'
                    ? const Icon(Icons.check, color: Colors.green)
                    : ElevatedButton(
                        onPressed: () => _approve(r['id']),
                        child: const Text('اعتماد'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

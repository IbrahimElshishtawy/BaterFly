import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_client.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final _whatsapp = TextEditingController();
  final _email = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await Supa.client
        .from('settings')
        .select()
        .eq('id', 1)
        .maybeSingle();
    if (res != null) {
      _whatsapp.text = res['whatsapp_number'] ?? '';
      _email.text = res['support_email'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    await Supa.client.from('settings').upsert({
      'id': 1,
      'whatsapp_number': _whatsapp.text.trim(),
      'support_email': _email.text.trim(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _whatsapp,
              decoration: const InputDecoration(labelText: 'رقم واتساب'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'بريد الدعم'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('حفظ')),
          ],
        ),
      ),
    );
  }
}

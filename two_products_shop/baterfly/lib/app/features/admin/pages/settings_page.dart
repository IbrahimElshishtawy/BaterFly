import 'package:flutter/material.dart';
import '../../../services/supabase/supabase_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _sb = Supa.client;
  final whatsapp = TextEditingController();
  final email = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await _sb.from('settings').select().eq('id', 1).maybeSingle();
    if (res != null) {
      whatsapp.text = res['whatsapp_number'] ?? '';
      email.text = res['support_email'] ?? '';
    }
  }

  Future<void> _save() async {
    setState(() => saving = true);
    await _sb
        .from('settings')
        .update({'whatsapp_number': whatsapp.text, 'support_email': email.text})
        .eq('id', 1);
    setState(() => saving = false);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم الحفظ بنجاح')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات العامة')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: whatsapp,
              decoration: const InputDecoration(labelText: 'رقم واتساب'),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'بريد الدعم'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saving ? null : _save,
              child: saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('حفظ التغييرات'),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/app/features/admin/pages/settings_page.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../../../core/widgets/site_app_bar/site_app_bar.dart';
import '../../../features/product/widgets/gradient_bg.dart';
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
      appBar: const SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const SizedBox(height: 24),
                TextField(
                  controller: whatsapp,
                  decoration: InputDecoration(
                    labelText: 'رقم واتساب',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.95),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'بريد الدعم',
                    labelStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.95),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: saving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

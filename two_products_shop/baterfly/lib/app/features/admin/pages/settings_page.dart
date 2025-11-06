// pages/settings_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:baterfly/app/services/supabase/admin_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AdminService _svc = AdminService();
  bool loading = true;
  Map<String, dynamic>? settings;

  final _whatsapp = TextEditingController();
  final _email = TextEditingController();
  final _shipping = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _svc.fetchSettings();
    settings = s;
    _whatsapp.text = s?['whatsapp_number'] ?? '';
    _email.text = s?['suport_email'] ?? '';
    _shipping.text = s?['shipping_matrix'] ?? '';
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await _svc.updateSettings({
      'id': settings?['id'] ?? 1,
      'whatsapp_number': _whatsapp.text,
      'suport_email': _email.text,
      'shipping_matrix': _shipping.text,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _whatsapp,
            decoration: const InputDecoration(labelText: 'WhatsApp'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Support Email'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _shipping,
            decoration: const InputDecoration(labelText: 'Shipping Matrix'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: const Text('حفظ الإعدادات')),
        ],
      ),
    );
  }
}

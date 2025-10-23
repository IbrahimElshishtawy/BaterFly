import 'package:flutter/material.dart';
import 'thank_you_page.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _sending = false;

  void _confirm() async {
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _sending = false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ThankYouPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text('شراء ${p['name']}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'الاسم الكامل'),
            ),
            TextField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            ),
            TextField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _sending ? null : _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: const Size.fromHeight(50),
              ),
              child: _sending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('تأكيد الطلب', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

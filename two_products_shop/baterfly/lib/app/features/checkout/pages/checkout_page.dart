import 'package:flutter/material.dart';
import '../../../data/datasources/remote/orders_remote.dart';
import 'thank_you_page.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final _remote = OrdersRemote();
  int qty = 1;
  bool sending = false;

  Future<void> _confirmOrder() async {
    if (name.text.trim().length < 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الاسم لا يقل عن 10 أحرف')));
      return;
    }
    if (address.text.trim().length < 15) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('العنوان لا يقل عن 15 حرف')));
      return;
    }
    setState(() => sending = true);
    try {
      final res = await _remote.createOrder(
        productId: widget.product['id'] as int,
        quantity: qty,
        fullName: name.text.trim(),
        phone1: phone.text.trim(),
        addressText: address.text.trim(),
      );
      final orderNo = res['order_no']?.toString() ?? '—';
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ThankYouPage(
            orderNo: orderNo,
            productName: widget.product['name'] as String,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إنشاء الطلب: $e')));
    } finally {
      if (mounted) setState(() => sending = false);
    }
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
            DropdownButtonFormField<int>(
              initialValue: qty,
              decoration: const InputDecoration(labelText: 'الكمية'),
              items: List.generate(5, (i) => i + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) => setState(() => qty = v ?? 1),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'الاسم الكامل'),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: address,
              decoration: const InputDecoration(labelText: 'العنوان الكامل'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: sending ? null : _confirmOrder,
              child: sending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('تأكيد الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}

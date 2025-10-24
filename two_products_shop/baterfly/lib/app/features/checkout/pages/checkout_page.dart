// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/datasources/remote/orders_remote.dart';
import 'thank_you_page.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone1 = TextEditingController();
  final _phone2 = TextEditingController();
  final _address = TextEditingController();
  final _remote = OrdersRemote();

  int _qty = 1;
  bool _sending = false;

  String? _vName(String? v) =>
      (v == null || v.trim().length < 10) ? 'الاسم لا يقل عن 10 أحرف' : null;

  String? _vPhoneRequired(String? v) {
    final s = v?.trim() ?? '';
    final ok = RegExp(r'^\d{8,15}$').hasMatch(s);
    return ok ? null : 'اكتب رقم صحيح من 8–15 رقم';
  }

  String? _vPhoneOptional(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return null;
    final ok = RegExp(r'^\d{8,15}$').hasMatch(s);
    return ok ? null : 'رقم غير صالح';
  }

  String? _vAddress(String? v) =>
      (v == null || v.trim().length < 15) ? 'العنوان لا يقل عن 15 حرف' : null;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      final res = await _remote.createOrder(
        productId: widget.product['id'] as int,
        quantity: _qty,
        fullName: _name.text.trim(),
        phone1: _phone1.text.trim(),
        phone2: _phone2.text.trim().isEmpty ? null : _phone2.text.trim(),
        addressText: _address.text.trim(),
      );
      final orderNo = res['order_no']?.toString() ?? '—';
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
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final price = (p['price'] as num).toDouble();
    final total = price * _qty;

    return Scaffold(
      appBar: AppBar(title: Text('شراء ${p['name']}')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ملخص المنتج
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Colors.black12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          (p['image'] as String?) ??
                              'https://via.placeholder.com/200x260?text=Product',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<int>(
                              initialValue: _qty,
                              decoration: const InputDecoration(
                                labelText: 'الكمية',
                              ),
                              items: List.generate(
                                5,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1}'),
                                ),
                              ),
                              onChanged: (v) =>
                                  setState(() => _qty = v ?? _qty),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${price.toStringAsFixed(0)} ج.م/قطعة'),
                          const SizedBox(height: 6),
                          Text(
                            'الإجمالي: ${total.toStringAsFixed(0)} ج.م',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // النموذج
              Form(
                key: _form,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'الاسم الكامل',
                          ),
                          validator: _vName,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phone1,
                                decoration: const InputDecoration(
                                  labelText: 'رقم الهاتف 1',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: _vPhoneRequired,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _phone2,
                                decoration: const InputDecoration(
                                  labelText: 'رقم الهاتف 2 (اختياري)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: _vPhoneOptional,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _address,
                          decoration: const InputDecoration(
                            labelText: 'العنوان الكامل',
                          ),
                          maxLines: 2,
                          validator: _vAddress,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // زر التأكيد
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: _sending
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('تأكيد الطلب'),
                  ),
                  onPressed: _sending ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

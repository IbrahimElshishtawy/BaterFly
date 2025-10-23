// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/datasources/remote/orders_remote.dart';

class OrderForm extends StatefulWidget {
  final Map<String, dynamic> product;
  const OrderForm({super.key, required this.product});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _f = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone1 = TextEditingController();
  final _phone2 = TextEditingController();
  final _addr = TextEditingController();
  int _qty = 1;
  bool _savingLoc = false;
  final _remote = OrdersRemote();

  @override
  Widget build(BuildContext context) {
    final radius = const Radius.circular(22);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Form(
          key: _f,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 45,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  'طلب ${widget.product['name']}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        _name,
                        'الاسم الكامل',
                        (v) =>
                            v!.trim().length < 10 ? 'أدخل اسمًا صحيحًا' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 90,
                      child: DropdownButtonFormField<int>(
                        initialValue: _qty,
                        decoration: const InputDecoration(labelText: 'الكمية'),
                        items: List.generate(5, (i) => i + 1)
                            .map(
                              (e) =>
                                  DropdownMenuItem(value: e, child: Text('$e')),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _qty = v ?? 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _numField(_phone1, 'رقم الهاتف 1', required: true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _numField(_phone2, 'رقم الهاتف 2 (اختياري)'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _field(
                  _addr,
                  'العنوان الكامل',
                  (v) => v!.trim().length < 15 ? 'أدخل عنوانًا مفصلًا' : null,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () async {
                      setState(() => _savingLoc = true);
                      await Future.delayed(
                        const Duration(milliseconds: 500),
                      ); // placeholder
                      setState(() => _savingLoc = false);
                    },
                    icon: _savingLoc
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_outlined, size: 18),
                    label: const Text('حفظ موقعي'),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (!_f.currentState!.validate()) return;
                      final res = await _remote.createOrder(
                        productId: widget.product['id'] as int,
                        quantity: _qty,
                        fullName: _name.text.trim(),
                        phone1: _phone1.text.trim(),
                        phone2: _phone2.text.trim().isEmpty
                            ? null
                            : _phone2.text.trim(),
                        addressText: _addr.text.trim(),
                      );
                      if (!mounted) return;
                      final no = res['order_no']?.toString() ?? '—';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم تسجيل الطلب رقم $no')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('تأكيد الطلب'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    String? Function(String?)? v, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label),
      validator: v,
      maxLines: maxLines,
    );
  }

  Widget _numField(
    TextEditingController c,
    String label, {
    bool required = false,
  }) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (v) {
        if (!required && (v == null || v.isEmpty)) return null;
        final ok = RegExp(r'^\d{8,15}$').hasMatch(v!);
        return ok ? null : 'رقم غير صالح';
      },
    );
  }
}

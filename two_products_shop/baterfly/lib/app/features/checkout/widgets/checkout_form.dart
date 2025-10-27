// lib/app/features/catalog/widgets/checkout_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckoutForm extends StatefulWidget {
  final Map<String, dynamic> product;

  const CheckoutForm({super.key, required this.product});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone1 = TextEditingController();
  final _phone2 = TextEditingController();
  final _address = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'الاسم الكامل',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: _vName,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone1,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف 1',
              prefixIcon: Icon(Icons.phone_android),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _vPhoneRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone2,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف 2 (اختياري)',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _vPhoneOptional,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address,
            decoration: const InputDecoration(
              labelText: 'العنوان الكامل',
              prefixIcon: Icon(Icons.home_outlined),
            ),
            maxLines: 2,
            validator: _vAddress,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _sending
                ? null
                : () {
                    // Save function here
                  },
            child: _sending
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('تأكيد الطلب'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OrderForm extends StatefulWidget {
  final void Function({
    required String fullName,
    required String phone,
    required String address,
  })
  onSubmit;
  const OrderForm({super.key, required this.onSubmit});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'الاسم الكامل'),
        ),
        TextField(
          controller: phone,
          decoration: const InputDecoration(labelText: 'رقم الهاتف'),
        ),
        TextField(
          controller: address,
          decoration: const InputDecoration(labelText: 'العنوان'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => widget.onSubmit(
            fullName: name.text,
            phone: phone.text,
            address: address.text,
          ),
          child: const Text('متابعة'),
        ),
      ],
    );
  }
}

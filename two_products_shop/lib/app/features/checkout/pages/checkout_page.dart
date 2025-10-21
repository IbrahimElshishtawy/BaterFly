import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../core/routing/app_router.dart';
import '../../../services/supabase/supabase_client.dart';
import '../../../core/config/app_constants.dart';

class CheckoutPage extends StatefulWidget {
  final int productId;
  const CheckoutPage({super.key, required this.productId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final order = {
      'product_id': widget.productId,
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'address': _address.text.trim(),
    };

    try {
      await Supa.client.from(AppConstants.tblOrders).insert(order);
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRouter.thankYou,
          arguments: {'orderNo': DateTime.now().millisecondsSinceEpoch},
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل حفظ الطلب: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                validator: Validators.fullName,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                validator: Validators.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  labelText: 'العنوان بالتفصيل',
                ),
                validator: Validators.address,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('تأكيد الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

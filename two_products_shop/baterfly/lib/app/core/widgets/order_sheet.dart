import 'package:baterfly/app/core/utils/validators.dart';
import 'package:baterfly/app/data/datasources/remote/orders_remote.dart';
import 'package:flutter/material.dart';

class OrderSheet extends StatefulWidget {
  final int productId;
  final String productName;
  const OrderSheet({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends State<OrderSheet>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone1 = TextEditingController();
  final _phone2 = TextEditingController();
  final _address = TextEditingController();
  int _qty = 1;
  bool _saveLoc = false;
  bool _loading = false;

  final _orders = OrdersRemote();

  String? _vName(String? v) =>
      (v ?? '').trim().length < 10 ? 'الاسم 10 أحرف على الأقل' : null;
  String? _vPhone(String? v) =>
      Validators.phone(v ?? '') ? null : 'رقم غير صالح';
  String? _vAddr(String? v) =>
      (v ?? '').trim().length < 15 ? 'العنوان قصير' : null;

  @override
  void dispose() {
    _fullName.dispose();
    _phone1.dispose();
    _phone2.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final res = await _orders.createOrder(
        productId: widget.productId,
        quantity: _qty,
        fullName: _fullName.text.trim(),
        phone1: _phone1.text.trim(),
        phone2: _phone2.text.trim().isEmpty ? null : _phone2.text.trim(),
        addressText: _address.text.trim(),
        notes: _saveLoc ? 'save_location=1' : null,
      );
      if (!mounted) return;
      Navigator.pop(context, res['order_no']?.toString());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إنشاء الطلب: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = const Radius.circular(24);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16 + 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        boxShadow: const [BoxShadow(blurRadius: 18, color: Colors.black26)],
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 56,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'طلب: ${widget.productName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fullName,
                  decoration: const InputDecoration(labelText: 'الاسم بالكامل'),
                  validator: _vName,
                  textInputAction: TextInputAction.next,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phone1,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف 1',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _vPhone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phone2,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف 2',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(
                    labelText: 'العنوان الكامل',
                  ),
                  minLines: 2,
                  maxLines: 3,
                  validator: _vAddr,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('الكمية'),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$_qty'),
                    IconButton(
                      onPressed: _qty < 5 ? () => setState(() => _qty++) : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Switch(
                          value: _saveLoc,
                          onChanged: (v) => setState(() => _saveLoc = v),
                        ),
                        const Text('حفظ الموقع'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.shopping_bag),
                    label: const Text('اطلب الآن'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

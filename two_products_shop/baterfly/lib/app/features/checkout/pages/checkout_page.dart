// ignore_for_file: use_build_context_synchronously

import 'package:baterfly/app/core/utils/responsive.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/datasources/remote/orders_remote.dart';
import '../../../core/widgets/footer_links.dart';
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
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: const [
              ListTile(
                title: Center(
                  child: Text(
                    'القائمة',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Divider(),
              ListTile(title: Text('سياسة الاستبدال والاسترجاع')),
              ListTile(title: Text('سياسة الشحن')),
              ListTile(title: Text('التواصل مع الدعم')),
            ],
          ),
        ),
      ),
      appBar: const SiteAppBar(transparent: false),

      body: Stack(
        children: [
          const GradientBackground(),

          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final pad = Responsive.hpad(w);
              final maxW = Responsive.maxWidth(w);

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: ListView(
                    padding: pad.copyWith(top: 40, bottom: 40),
                    children: [
                      // العنوان
                      Center(
                        child: Text(
                          'إتمام الطلب',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // بطاقة المنتج
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  (p['image'] as String?) ??
                                      'https://via.placeholder.com/300x300?text=Product',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<int>(
                                      value: _qty,
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
                                          setState(() => _qty = v ?? 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${price.toStringAsFixed(0)} ج.م / قطعة',
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'الإجمالي: ${total.toStringAsFixed(0)} ج.م',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // نموذج البيانات
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _form,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'بيانات الشحن',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _name,
                                  decoration: const InputDecoration(
                                    labelText: 'الاسم الكامل',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: _vName,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _phone1,
                                        decoration: const InputDecoration(
                                          labelText: 'رقم الهاتف 1',
                                          prefixIcon: Icon(Icons.phone_android),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
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
                                          prefixIcon: Icon(Icons.phone),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        validator: _vPhoneOptional,
                                      ),
                                    ),
                                  ],
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // زر التأكيد
                      Center(
                        child: SizedBox(
                          width: 300,
                          height: 54,
                          child: FilledButton.icon(
                            icon: _sending
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.check_circle_outline),
                            label: const Text(
                              'تأكيد الطلب',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: _sending ? null : _submit,
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // الفوتر
                      const FooterLinks(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

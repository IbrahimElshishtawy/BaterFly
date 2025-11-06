// ignore_for_file: unused_field, prefer_final_fields

import 'package:baterfly/app/features/checkout/pages/thank_you_page.dart';
import 'package:baterfly/app/services/supabase/checkout_service.dart';
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

  bool _sending = false;

  String? _selectedCity;
  String? _selectedArea;

  final CheckoutService _service = CheckoutService();

  final Map<String, List<String>> _areasByCity = {
    'القاهرة': ['مدينة نصر', 'مصر الجديدة', 'المعادي', 'الزيتون', 'شبرا'],
    'الجيزة': ['الهرم', 'الدقي', 'العجوزة', 'إمبابة', 'أكتوبر'],
    'الإسكندرية': ['سموحة', 'العصافرة', 'محرم بك', 'المنتزه'],
    'طنطا': ['القرشي', 'سيجر', 'الجمهورية', 'الاستاد'],
    'المنصورة': ['حي الجامعة', 'طلخا', 'جديلة', 'شارع جيهان'],
  };

  // ✅ Validators
  String? _vName(String? v) =>
      (v == null || v.trim().length < 10) ? 'الاسم لا يقل عن 10 أحرف' : null;

  String? _vPhoneRequired(String? v) {
    final ok = RegExp(r'^\d{8,15}$').hasMatch(v?.trim() ?? '');
    return ok ? null : 'اكتب رقم صحيح من 8–15 رقم';
  }

  String? _vPhoneOptional(String? v) {
    if (v!.isEmpty) return null;
    final ok = RegExp(r'^\d{8,15}$').hasMatch(v.trim());
    return ok ? null : 'رقم غير صالح';
  }

  String? _vAddress(String? v) =>
      (v == null || v.trim().length < 15) ? 'العنوان لا يقل عن 15 حرف' : null;

  // ✅ Send Order to Supabase
  Future<void> _submitOrder() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _sending = true);

    try {
      final orderId = await _service.sendOrder(
        orderData: {
          'full_name': _name.text.trim(),
          'phone1': _phone1.text.trim(),
          'phone2': _phone2.text.trim(),
          'city': _selectedCity,
          'area': _selectedArea,
          'address_text': _address.text.trim(),
          'address_norm': '',
          'notes': '',
          'status': 'pending',
          'payment_method': 'cash_on_delivery',
          'product_id': widget.product['id'],
          'quantity': 1,
          //'id': '',
          'session_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ThankYouPage(
            orderNo: orderId,
            productName: widget.product['name'] ?? 'منتجك',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إرسال الطلب: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          // ✅ اسم العميل (يسمح بحروف)
          _buildTextField(
            controller: _name,
            label: 'الاسم الكامل',
            icon: Icons.person_outline,
            validator: _vName,
            keyboardType: TextInputType.text,
            formatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z\u0600-\u06FF ]'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ✅ رقم الهاتف 1 (أرقام فقط)
          _buildTextField(
            controller: _phone1,
            label: 'رقم الهاتف 1',
            icon: Icons.phone_android,
            validator: _vPhoneRequired,
            keyboardType: TextInputType.phone,
            formatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),

          // ✅ رقم الهاتف 2 (أرقام فقط)
          _buildTextField(
            controller: _phone2,
            label: 'رقم الهاتف 2 (اختياري)',
            icon: Icons.phone,
            validator: _vPhoneOptional,
            keyboardType: TextInputType.phone,
            formatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: _decoration('المدينة', Icons.location_city),
            items: _areasByCity.keys
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
            onChanged: (v) => setState(() {
              _selectedCity = v;
              _selectedArea = null;
            }),
            validator: (v) => v == null ? 'اختار المدينة' : null,
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _selectedArea,
            decoration: _decoration('المنطقة', Icons.map_outlined),
            items:
                (_selectedCity == null
                        ? <String>[]
                        : _areasByCity[_selectedCity] ?? <String>[])
                    .map(
                      (area) => DropdownMenuItem<String>(
                        value: area,
                        child: Text(area),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => _selectedArea = v),
            validator: (v) => v == null ? 'اختار المنطقة' : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _address,
            decoration: _decoration('العنوان الكامل', Icons.home_outlined),
            validator: _vAddress,
            maxLines: 2,
          ),
          const SizedBox(height: 20),

          _buildSubmitBtn(),
        ],
      ),
    );
  }

  // ✅ Decoration wrapper
  InputDecoration _decoration(String text, IconData icon) => InputDecoration(
    labelText: text,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  // ✅ Submit button
  Widget _buildSubmitBtn() => SizedBox(
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3527B0), Color(0xFFE91E63)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: _sending ? null : _submitOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _sending
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'تأكيد الطلب',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ),
  );

  // ✅ Flexible TextField Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) => TextFormField(
    controller: controller,
    decoration: _decoration(label, icon),
    keyboardType: keyboardType,
    inputFormatters: formatters,
    validator: validator,
  );
}

// ignore_for_file: unused_field, prefer_final_fields

import 'package:baterfly/app/features/checkout/pages/thank_you_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // 🔹 المدن والمناطق
  final Map<String, List<String>> _areasByCity = {
    'القاهرة': ['مدينة نصر', 'مصر الجديدة', 'المعادي', 'الزيتون', 'شبرا'],
    'الجيزة': ['الهرم', 'الدقي', 'العجوزة', 'إمبابة', 'أكتوبر'],
    'الإسكندرية': ['سموحة', 'العصافرة', 'محرم بك', 'المنتزه'],
    'طنطا': ['القرشي', 'سيجر', 'الجمهورية', 'الاستاد'],
    'المنصورة': ['حي الجامعة', 'طلخا', 'جديلة', 'شارع جيهان'],
  };

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

  Future<void> _submitOrder() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _sending = true);

    try {
      final response = await Supabase.instance.client
          .from('order')
          .insert({
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
            'ip': '',
            'session_id': DateTime.now().millisecondsSinceEpoch.toString(),
            'create_at': DateTime.now().toIso8601String(),
          })
          .select('order_no')
          .single();

      final orderNo = response['order_no'].toString();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ThankYouPage(
              orderNo: orderNo,
              productName: widget.product['name'] ?? 'منتجك',
            ),
          ),
        );
      }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الاسم
          TextFormField(
            controller: _name,
            decoration: InputDecoration(
              labelText: 'الاسم الكامل',
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: _vName,
          ),
          const SizedBox(height: 12),

          // رقم الهاتف 1
          TextFormField(
            controller: _phone1,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف 1',
              prefixIcon: const Icon(Icons.phone_android),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _vPhoneRequired,
          ),
          const SizedBox(height: 12),

          // رقم الهاتف 2 (اختياري)
          TextFormField(
            controller: _phone2,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف 2 (اختياري)',
              prefixIcon: const Icon(Icons.phone),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _vPhoneOptional,
          ),
          const SizedBox(height: 12),

          // اختيار المدينة
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'المدينة',
              prefixIcon: const Icon(Icons.location_city),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            value: _selectedCity,
            items: _areasByCity.keys
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCity = value;
                _selectedArea = null; // إعادة ضبط المنطقة
              });
            },
            validator: (v) => v == null ? 'اختار المدينة' : null,
          ),
          const SizedBox(height: 12),

          // اختيار المنطقة
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'المنطقة',
              prefixIcon: const Icon(Icons.map_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            value: _selectedArea,
            items:
                (_selectedCity == null
                        ? <String>[]
                        : _areasByCity[_selectedCity] ?? [])
                    .map(
                      (area) =>
                          DropdownMenuItem(value: area, child: Text(area)),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _selectedArea = value),
            validator: (v) => v == null ? 'اختار المنطقة' : null,
          ),
          const SizedBox(height: 12),

          // العنوان الكامل
          TextFormField(
            controller: _address,
            decoration: InputDecoration(
              labelText: 'العنوان الكامل',
              prefixIcon: const Icon(Icons.home_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 2,
            validator: _vAddress,
          ),
          const SizedBox(height: 20),

          // زر التأكيد
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3527B0), Color(0xFFE91E63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                onPressed: _sending ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _sending
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'تأكيد الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

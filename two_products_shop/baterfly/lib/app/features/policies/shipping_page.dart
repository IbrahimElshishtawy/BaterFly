import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';

import 'package:flutter/material.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان الرئيسي
                    Row(
                      children: const [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: Color(0xFF2A82FF),
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'سياسة الشحن والتوصيل',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0E1A2A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // فقرة تمهيدية
                    Text(
                      'نلتزم في "لمسة حرير" بتوصيل طلباتكم بسرعة وأمان إلى جميع محافظات مصر. نعمل مع شركاء شحن موثوقين لضمان تجربة تسوق سهلة ومريحة. فيما يلي تفاصيل سياسة الشحن الخاصة بنا:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // البنود
                    const _PolicyItem(
                      number: '1',
                      title: 'مدة التوصيل',
                      text:
                          'تُسلَّم الطلبات داخل القاهرة والجيزة خلال 2-3 أيام عمل، بينما باقي المحافظات خلال 3-5 أيام عمل من تاريخ تأكيد الطلب.',
                    ),
                    const _PolicyItem(
                      number: '2',
                      title: 'رسوم الشحن',
                      text:
                          'تُحدد رسوم الشحن حسب موقع العميل والوزن الإجمالي للطلب. قد تتوفر عروض خاصة للشحن المجاني في فترات محددة.',
                    ),
                    const _PolicyItem(
                      number: '3',
                      title: 'تتبع الشحنة',
                      text:
                          'بمجرد شحن طلبك، ستتلقى رسالة عبر واتساب أو البريد الإلكتروني تحتوي على رقم التتبع لتتمكن من متابعة الطلب حتى الاستلام.',
                    ),
                    const _PolicyItem(
                      number: '4',
                      title: 'محاولات التسليم',
                      text:
                          'يقوم مندوب الشحن بمحاولتين للتسليم. في حال عدم الرد أو تأجيل الاستلام، يتم التواصل مع العميل لتحديد موعد جديد.',
                    ),
                    const _PolicyItem(
                      number: '5',
                      title: 'تلف أو فقدان أثناء الشحن',
                      text:
                          'نضمن استبدال أو استرجاع أي منتج تعرض للتلف أثناء النقل بعد التحقق من البلاغ خلال 24 ساعة من الاستلام.',
                    ),

                    const SizedBox(height: 32),

                    // ملاحظة ختامية
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F7FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF2A82FF),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'يرجى التأكد من إدخال عنوان التوصيل ورقم الهاتف بشكل صحيح لتجنب أي تأخير في الشحن.',
                              style: TextStyle(
                                fontSize: 15.5,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SliverToBoxAdapter(child: FooterLinks()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const _PolicyItem({
    required this.number,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), // خلفية شبه شفافة
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000), // ظل خفيف
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2A82FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0E1A2A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

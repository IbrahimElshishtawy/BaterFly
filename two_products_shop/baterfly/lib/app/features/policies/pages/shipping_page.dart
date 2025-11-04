// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/policies/widget/Policy_Item.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:flutter/material.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: true),
      body: Stack(
        children: [
          const GradientBackground(), // الخلفية Gradient
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                sliver: SliverToBoxAdapter(
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
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'سياسة الشحن والتوصيل',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // فقرة تمهيدية
                          const Text(
                            'نلتزم في "لمسة حرير" بتوصيل طلباتكم بسرعة وأمان إلى جميع محافظات مصر. نعمل مع شركاء شحن موثوقين لضمان تجربة تسوق سهلة ومريحة. فيما يلي تفاصيل سياسة الشحن الخاصة بنا:',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // البنود
                          const PolicyItem(
                            number: '1',
                            title: 'مدة التوصيل',
                            text:
                                'تُسلَّم الطلبات داخل القاهرة والجيزة خلال 2-3 أيام عمل، بينما باقي المحافظات خلال 3-5 أيام عمل من تاريخ تأكيد الطلب.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '2',
                            title: 'رسوم الشحن',
                            text:
                                'تُحدد رسوم الشحن حسب موقع العميل والوزن الإجمالي للطلب. قد تتوفر عروض خاصة للشحن المجاني في فترات محددة.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '3',
                            title: 'تتبع الشحنة',
                            text:
                                'بمجرد شحن طلبك، ستتلقى رسالة عبر واتساب أو البريد الإلكتروني تحتوي على رقم التتبع لتتمكن من متابعة الطلب حتى الاستلام.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '4',
                            title: 'محاولات التسليم',
                            text:
                                'يقوم مندوب الشحن بمحاولتين للتسليم. في حال عدم الرد أو تأجيل الاستلام، يتم التواصل مع العميل لتحديد موعد جديد.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '5',
                            title: 'تلف أو فقدان أثناء الشحن',
                            text:
                                'نضمن استبدال أو استرجاع أي منتج تعرض للتلف أثناء النقل بعد التحقق من البلاغ خلال 24 ساعة من الاستلام.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const SizedBox(height: 32),

                          // ملاحظة ختامية
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'يرجى التأكد من إدخال عنوان التوصيل ورقم الهاتف بشكل صحيح لتجنب أي تأخير في الشحن.',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Footer
              const SliverToBoxAdapter(child: FooterLinks()),
            ],
          ),
        ],
      ),
    );
  }
}

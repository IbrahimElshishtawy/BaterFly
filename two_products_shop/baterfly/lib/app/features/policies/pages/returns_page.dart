// ignore_for_file: deprecated_member_use

import 'package:baterfly/app/core/widgets/footer_links/footer_links.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/CustomDrawer.dart';
import 'package:baterfly/app/core/widgets/site_app_bar/site_app_bar.dart';
import 'package:baterfly/app/features/policies/widget/Policy_Item.dart';
import 'package:baterfly/app/features/product/widgets/gradient_bg.dart';
import 'package:flutter/material.dart';

class ReturnsPage extends StatelessWidget {
  const ReturnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: SiteAppBar(transparent: false),
      body: Stack(
        children: [
          const GradientBackground(),
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
                                Icons.assignment_return_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'سياسة الاستبدال والاسترجاع',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // كارد المقدمة
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Text(
                              'نحرص في "ButterFly & Melina Cosmetics" على رضا عملائنا التام عن مشترياتهم. إذا واجهت أي مشكلة في المنتج الذي استلمته، يمكنك طلب استبداله أو استرجاعه خلال فترة محددة وفقًا للشروط التالية:',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.8,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // البنود
                          const PolicyItem(
                            number: '1',
                            title: 'مدة الاسترجاع والاستبدال',
                            text:
                                'يمكنك طلب استرجاع أو استبدال المنتج خلال 14 يومًا من تاريخ الاستلام بشرط أن يكون المنتج في حالته الأصلية ولم يُستخدم أو يُفتح.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '2',
                            title: 'حالة المنتج عند الإرجاع',
                            text:
                                'يجب أن يكون المنتج مغلفًا كما تم استلامه مع جميع الملحقات والفاتورة الأصلية. في حال وجود تلف أو استخدام للمنتج لا يُقبل الطلب.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '3',
                            title: 'المنتجات غير القابلة للإرجاع',
                            text:
                                'المنتجات الشخصية أو التي تُستخدم مباشرة على البشرة لا يمكن إرجاعها بعد فتح التغليف حفاظًا على السلامة الصحية.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '4',
                            title: 'رسوم الشحن والإرجاع',
                            text:
                                'يُخصم مبلغ الشحن من المبلغ المسترد ما لم يكن سبب الإرجاع خطأ من طرفنا أو وجود خلل في المنتج.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),
                          const PolicyItem(
                            number: '5',
                            title: 'طريقة استرداد المبلغ',
                            text:
                                'يتم استرداد المبلغ خلال 5-7 أيام عمل عبر نفس وسيلة الدفع المستخدمة في الطلب.',
                            textColor: Colors.white,
                            bgColor: Colors.white24,
                          ),

                          const SizedBox(height: 32),

                          // كارد الدعم الفني
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.headset_mic_outlined,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'لأي استفسار إضافي أو لبدء طلب استرجاع، يمكنك التواصل معنا عبر صفحة الدعم الفني أو على واتساب.',
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

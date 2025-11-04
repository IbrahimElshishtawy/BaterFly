import 'package:flutter/material.dart';

class ReturnsPage extends StatelessWidget {
  const ReturnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
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
                      Icons.assignment_return_outlined,
                      color: Color(0xFF2A82FF),
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'سياسة الاستبدال والاسترجاع',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0E1A2A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // كارد المقدمة
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'نحرص في "BatterFly" على رضا عملائنا التام عن مشترياتهم. إذا واجهت أي مشكلة في المنتج الذي استلمته، يمكنك طلب استبداله أو استرجاعه خلال فترة محددة وفقًا للشروط التالية:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // البنود
                _PolicyItem(
                  number: '1',
                  title: 'مدة الاسترجاع والاستبدال',
                  text:
                      'يمكنك طلب استرجاع أو استبدال المنتج خلال 14 يومًا من تاريخ الاستلام بشرط أن يكون المنتج في حالته الأصلية ولم يُستخدم أو يُفتح.',
                ),
                _PolicyItem(
                  number: '2',
                  title: 'حالة المنتج عند الإرجاع',
                  text:
                      'يجب أن يكون المنتج مغلفًا كما تم استلامه مع جميع الملحقات والفاتورة الأصلية. في حال وجود تلف أو استخدام للمنتج لا يُقبل الطلب.',
                ),
                _PolicyItem(
                  number: '3',
                  title: 'المنتجات غير القابلة للإرجاع',
                  text:
                      'المنتجات الشخصية أو التي تُستخدم مباشرة على البشرة لا يمكن إرجاعها بعد فتح التغليف حفاظًا على السلامة الصحية.',
                ),
                _PolicyItem(
                  number: '4',
                  title: 'رسوم الشحن والإرجاع',
                  text:
                      'يُخصم مبلغ الشحن من المبلغ المسترد ما لم يكن سبب الإرجاع خطأ من طرفنا أو وجود خلل في المنتج.',
                ),
                _PolicyItem(
                  number: '5',
                  title: 'طريقة استرداد المبلغ',
                  text:
                      'يتم استرداد المبلغ خلال 5-7 أيام عمل عبر نفس وسيلة الدفع المستخدمة في الطلب.',
                ),

                const SizedBox(height: 32),

                // كارد الدعم الفني
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.headset_mic_outlined,
                          color: Color(0xFF2A82FF),
                          size: 26,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'لأي استفسار إضافي أو لبدء طلب استرجاع، يمكنك التواصل معنا عبر صفحة الدعم الفني أو على واتساب.',
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
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// عنصر مخصص لكل بند من السياسة بشكل كارد شفاف
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
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
                borderRadius: BorderRadius.circular(8),
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

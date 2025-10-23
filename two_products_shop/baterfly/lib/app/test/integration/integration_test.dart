// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import 'package:  two_products_shop/main.dart';

/// اختبار تكاملي بسيط لتأكيد أن التطبيق يعمل ويعرض الصفحة الأولى بدون أخطاء.
void main() {
  testWidgets('App launches and shows home page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Two Products Shop'), findsOneWidget);
  });
}

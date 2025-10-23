// ignore_for_file: depend_on_referenced_packages

import 'package:baterfly/main.dart';
import 'package:flutter_test/flutter_test.dart';

/// اختبار تكاملي بسيط لتأكيد أن التطبيق يعمل ويعرض الصفحة الأولى بدون أخطاء.
void main() {
  testWidgets('App launches and shows home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopApp());
    await tester.pumpAndSettle();

    expect(find.text('Two Products Shop'), findsOneWidget);
  });
}

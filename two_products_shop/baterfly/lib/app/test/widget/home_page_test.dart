// ignore_for_file: depend_on_referenced_packages

import 'package:baterfly/app/features/catalog/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('HomePage loads and shows loading indicator', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(initialQuery: '')),
    );

    // يجب أن يظهر مؤشر التحميل أولاً
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // انتظار اكتمال البيانات الوهمية
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}

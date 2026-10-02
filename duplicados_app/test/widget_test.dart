// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:duplicados_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and allow the splash screen to complete.
    await tester.pumpWidget(const DuplicadosApp());
    await tester.pump(const Duration(seconds: 2));

    // Verify that the app title is present.
    expect(find.text('Duplicados Photo & Video'), findsOneWidget);
  });
}

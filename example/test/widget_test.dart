import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:example/main.dart'; // nombre del package del example

void main() {
  testWidgets('renders schema title from DjsfForm', (
    WidgetTester tester,
  ) async {
    // Pump the app
    await tester.pumpWidget(const MyApp());

    // Expect to find the schema title on screen
    expect(find.text('A registration form'), findsOneWidget);
  });

  testWidgets('app has a MaterialApp & Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

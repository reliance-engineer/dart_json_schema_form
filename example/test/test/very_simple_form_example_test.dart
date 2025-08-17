import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/examples/very_simple_form_example.dart';

void main() {
  testWidgets('VerySimpleFormExample renders schema title & description', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VerySimpleFormExample()));

    // AppBar
    expect(find.text('DJSF Very Simple Example'), findsOneWidget);

    // Contenido DjsfForm (título y descripción del schema)
    expect(find.text('A registration form'), findsOneWidget);
    expect(find.text('Register users'), findsOneWidget);
  });
}

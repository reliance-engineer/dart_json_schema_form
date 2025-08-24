import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DjsfTextField on password renders with obscure true',
      (tester) async {
    final schema = {
      'properties': {
        'password': {'type': 'string', 'title': 'Password'},
      },
    };
    final ui = {
      "password": {"ui:widget": "password", "ui:help": "Make it strong"},
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DjsfForm(
            schema: schema,
            uiSchema: ui,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Make it strong'), findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    final obscure = textField.obscureText;

    // Expect numeric keyboard
    expect(obscure, isNotNull);
    expect(obscure, isTrue);
  });
}

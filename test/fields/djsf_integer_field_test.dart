import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

void main() {
  testWidgets('DjsfNumberField uses numeric keyboard', (tester) async {
    final schema = {
      'properties': {
        'age': {'type': 'integer', 'title': 'Age', 'minimum': 0},
      },
    };
    final ui = {
      'age': {
        'ui:placeholder': 'Your age',
        'ui:help': 'Must be at least 18',
      },
    };

    late TextInputType? effectiveKeyboardType;

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

    final textField = tester.widget<TextField>(find.byType(TextField));
    effectiveKeyboardType = textField.keyboardType;

    // Expect numeric keyboard
    expect(effectiveKeyboardType, isNotNull);
    expect(
      effectiveKeyboardType.index,
      equals(TextInputType.number.index),
      reason:
          'DjsfNumberField should default to a numeric keyboard (TextInputType.number)',
    );

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Your age'), findsOneWidget);
    expect(find.text('Must be at least 18'), findsOneWidget);
  });
}

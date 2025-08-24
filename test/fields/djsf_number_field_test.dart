import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/fields/defaults/number_field.dart';

import '../utils.dart';

void main() {
  testWidgets('DjsfNumberField uses numeric keyboard', (tester) async {
    final form = FormGroup({'age': FormControl<int>()});
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

    final ctx = DjsfFieldContext(
      form: form,
      schema: schema,
      uiSchema: ui,
      path: 'age',
      propSchema: schema['properties']?['age'] as Map<String, dynamic>,
      messages: FakeBundle(),
      transformErrors: null,
    );

    late TextInputType? effectiveKeyboardType;

    // Wrap field to introspect the widget tree
    final widget = MaterialApp(
      home: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: Builder(
            builder: (context) {
              final field = DjsfNumberField<int>(
                ctx: ctx,
                formControlName: 'age',
                keyboardType: TextInputType.number,
              );
              return field;
            },
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
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

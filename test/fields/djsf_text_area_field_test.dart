import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/fields/defaults/textarea_field.dart';

import '../utils.dart';

void main() {
  testWidgets('DjsfTextAreaField renders multiline', (tester) async {
    final form = FormGroup({'bio': FormControl<String>()});
    final schema = {
      'properties': {
        'bio': {'type': 'string', 'title': 'Bio'},
      },
    };
    final ui = {
      'bio': {
        'ui:options': {'inputType': 'textarea'},
        'ui:placeholder': 'Your bio',
        'ui:help': 'Tell us about you',
      },
    };

    final ctx = DjsfFieldContext(
      form: form,
      schema: schema,
      uiSchema: ui,
      path: 'bio',
      propSchema: schema['properties']?['bio'] as Map<String, dynamic>,
      messages: FakeBundle(),
      transformErrors: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReactiveForm(
            formGroup: form,
            child: DjsfTextAreaField(
              ctx: ctx,
              formControlName: 'bio',
            ),
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    // maxLines configured in your implementation (4)
    expect(textField.maxLines, equals(4));

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Your bio'), findsOneWidget);
    expect(find.text('Tell us about you'), findsOneWidget);
  });
}

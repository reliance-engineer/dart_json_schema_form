import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/fields/defaults/text_field.dart';

import '../utils.dart';

void main() {
  testWidgets('DjsfTextField renders hint/help', (tester) async {
    final form = FormGroup({'name': FormControl<String>()});
    final schema = {
      'properties': {
        'name': {'type': 'string', 'title': 'Name'},
      },
    };
    final ui = {
      'name': {
        'ui:placeholder': 'Full name',
        'ui:help': 'At least 2 words',
        'ui:emptyValue': 'N/A',
      },
    };

    final ctx = DjsfFieldContext(
      form: form,
      schema: schema,
      uiSchema: ui,
      path: 'name',
      propSchema: schema['properties']?['name'] as Map<String, dynamic>,
      messages: FakeBundle(),
      transformErrors: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReactiveForm(
            formGroup: form,
            child: DjsfTextField<String>(
              ctx: ctx,
              formControlName: 'name',
            ),
          ),
        ),
      ),
    );

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('At least 2 words'), findsOneWidget);
  });
}

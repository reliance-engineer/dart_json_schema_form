import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/renderers/form_renderer.dart';
import 'package:dart_json_schema_form/src/fields/registry.dart';

import '../utils.dart';

void main() {
  testWidgets(
      'FormRenderer resolves builder by ui:options.inputType, ui:widget, or type',
      (tester) async {
    final form = FormGroup({
      'email': FormControl<String>(),
      'pwd': FormControl<String>(),
      'age': FormControl<int>(),
    });

    final schema = {
      'properties': {
        'email': {'type': 'string', 'title': 'Email'},
        'pwd': {'type': 'string', 'title': 'Password'},
        'age': {'type': 'integer', 'title': 'Age'},
      },
    };

    final uiSchema = {
      'email': {
        'ui:options': {'inputType': 'email'},
      },
      'pwd': {
        'ui:widget': 'password',
      },
      // age resolves by its type = integer
    };

    // Spy registry: record keys used
    final usedKeys = <String>[];
    final spyRegistry = DjsfFieldRegistry({
      'email': (ctx) {
        usedKeys.add('email');
        return ReactiveTextField<String>(formControlName: ctx.path);
      },
      'password': (ctx) {
        usedKeys.add('password');
        return ReactiveTextField<String>(
          formControlName: ctx.path,
          obscureText: true,
        );
      },
      'integer': (ctx) {
        usedKeys.add('integer');
        return ReactiveTextField<int>(formControlName: ctx.path);
      },
      'string': (ctx) {
        usedKeys.add('string');
        return ReactiveTextField<String>(formControlName: ctx.path);
      },
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReactiveForm(
            formGroup: form,
            child: FormRenderer(
              form: form,
              schema: schema,
              uiSchema: uiSchema,
              messages: FakeBundle(),
              fieldRegistry: spyRegistry,
            ),
          ),
        ),
      ),
    );

    // All three fields are built:
    expect(find.byType(TextField), findsNWidgets(3));

    // Resolution order asserts:
    expect(
      usedKeys.contains('email'),
      isTrue,
      reason: 'email should be resolved via ui:options.inputType=email',
    );
    expect(
      usedKeys.contains('password'),
      isTrue,
      reason: 'pwd should resolve via ui:widget=password',
    );
    expect(
      usedKeys.contains('integer'),
      isTrue,
      reason: 'age should resolve via type=integer',
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/src/renderers/form_renderer.dart';

void main() {
  group('FormRenderer', () {
    testWidgets('renders nothing if properties is null or empty',
        (tester) async {
      final form = FormGroup({});
      final schema = {"title": "test"};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FormRenderer(form: form, schema: schema)),
        ),
      );

      // Should render an empty widget (SizedBox.shrink)
      expect(find.byType(ReactiveTextField), findsNothing);
    });

    testWidgets('renders a string field', (tester) async {
      final form = FormGroup({
        "firstName": FormControl<String>(),
      });
      final schema = {
        "properties": {
          "firstName": {"type": "string", "title": "First name"},
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveForm(
              formGroup: form,
              child: FormRenderer(form: form, schema: schema),
            ),
          ),
        ),
      );

      expect(
        find.widgetWithText(ReactiveTextField<String>, "First name"),
        findsOneWidget,
      );
    });

    testWidgets('renders an integer field', (tester) async {
      final form = FormGroup({
        "age": FormControl<int>(),
      });
      final schema = {
        "properties": {
          "age": {"type": "integer", "title": "Age"},
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReactiveForm(
              formGroup: form,
              child: FormRenderer(form: form, schema: schema),
            ),
          ),
        ),
      );

      expect(
        find.widgetWithText(ReactiveTextField<int>, "Age"),
        findsOneWidget,
      );
    });
  });
}

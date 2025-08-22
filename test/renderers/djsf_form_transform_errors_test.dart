import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

void main() {
  testWidgets('transformErrors modifies messages like RJSF', (tester) async {
    final schema = {
      "title": "Form",
      "required": ["email"],
      "properties": {
        "email": {
          "type": "string",
          "title": "Email",
          "pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$",
        },
      },
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DjsfForm(
            schema: schema,
            transformErrors: (errors) {
              return errors.map((e) {
                if (e.name == 'required' && e.property == '.email') {
                  e.message = 'Email is mandatory';
                }
                if (e.name == 'pattern' && e.property == '.email') {
                  e.message = 'Email format is not valid';
                }
                return e;
              }).toList();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // trigger required
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Email is mandatory'), findsOneWidget);

    // trigger pattern
    await tester.enterText(find.byType(TextField).first, 'nope');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Email format is not valid'), findsOneWidget);
  });
}

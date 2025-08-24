import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

void main() {
  testWidgets('DjsfTextAreaField renders multiline', (tester) async {
    final schema = {
      'properties': {
        'bio': {'type': 'string', 'title': 'Bio'},
      },
    };
    final ui = {
      'bio': {
        'ui:widget': 'textarea',
        'ui:options': {'inputType': 'textarea'},
        'ui:placeholder': 'Your bio',
        'ui:help': 'Tell us about you',
      },
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

    final textField = tester.widget<TextField>(find.byType(TextField));
    // maxLines configured in your implementation (4)
    expect(textField.maxLines, equals(4));

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Your bio'), findsOneWidget);
    expect(find.text('Tell us about you'), findsOneWidget);
  });
}

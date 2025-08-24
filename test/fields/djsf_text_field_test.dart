import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

void main() {
  testWidgets('DjsfTextField renders for string', (tester) async {
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
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('At least 2 words'), findsOneWidget);
  });

  testWidgets('DjsfTextField renders for text', (tester) async {
    final schema = {
      'properties': {
        'name': {'type': 'string', 'title': 'Name'},
      },
    };
    final ui = {
      'name': {
        'ui:widget': 'text',
        'ui:placeholder': 'Full name',
        'ui:help': 'At least 2 words',
        'ui:emptyValue': 'N/A',
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

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('At least 2 words'), findsOneWidget);
  });

  testWidgets('DjsfTextField renders for email', (tester) async {
    final schema = {
      'properties': {
        'email': {'type': 'string', 'title': 'Email'},
      },
    };
    final ui = {
      'email': {
        "ui:options": {"inputType": "email"},
        'ui:placeholder': 'Email address',
        'ui:help': 'example@domain.com',
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

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('example@domain.com'), findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    final effectiveKeyboardType = textField.keyboardType;

    // Expect phone keyboard
    expect(effectiveKeyboardType, isNotNull);
    expect(
      effectiveKeyboardType.index,
      equals(TextInputType.emailAddress.index),
    );
  });

  testWidgets('DjsfTextField renders for phone', (tester) async {
    final schema = {
      'properties': {
        'telephone': {'type': 'string', 'title': 'Name'},
      },
    };
    final ui = {
      'telephone': {
        "ui:options": {"inputType": "tel"},
        'ui:placeholder': 'Your telephone',
        'ui:help': '+123456789',
        'ui:emptyValue': 'N/A',
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

    // Placeholder + helper are visible via InputDecoration
    expect(find.text('Your telephone'), findsOneWidget);
    expect(find.text('+123456789'), findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    final effectiveKeyboardType = textField.keyboardType;

    // Expect phone keyboard
    expect(effectiveKeyboardType, isNotNull);
    expect(
      effectiveKeyboardType.index,
      equals(TextInputType.phone.index),
    );
  });
}

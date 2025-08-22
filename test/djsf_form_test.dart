import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  group('DjsfForm', () {
    testWidgets('renders the schema title as text',
        (WidgetTester tester) async {
      // Arrange
      final schema = {
        "title": "A registration form",
        "type": "object",
        "properties": {
          "firstName": {"type": "string"},
        },
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(schema: schema),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text("A registration form"), findsOneWidget);
    });

    testWidgets('renders placeholder text if no title is provided',
        (WidgetTester tester) async {
      // Arrange
      final schema = {
        "type": "object",
        "properties": {
          "firstName": {"type": "string"},
        },
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(schema: schema),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text("DJSF Form Placeholder"), findsOneWidget);
    });
  });

  group('DjsfForm description rendering', () {
    testWidgets('shows description when present', (WidgetTester tester) async {
      final schema = {"description": "Register users", "properties": {}};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(schema: schema),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Register users'), findsOneWidget);
    });

    testWidgets('does not show description when missing',
        (WidgetTester tester) async {
      final schema = {"title": "A registration form", "properties": {}};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(schema: schema),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Register users'), findsNothing);
    });
  });

  group('DjsfForm fields rendering', () {
    testWidgets('renders string field from schema', (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "username": {"type": "string", "title": "Username"},
        },
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DjsfForm(schema: schema))),
      );

      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ReactiveTextField<String>, "Username"),
        findsOneWidget,
      );
    });

    testWidgets('renders integer field from schema', (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "age": {"type": "integer", "title": "Age"},
        },
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DjsfForm(schema: schema))),
      );

      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ReactiveTextField<int>, "Age"),
        findsOneWidget,
      );
    });

    testWidgets('renders multiple fields from schema', (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "firstName": {"type": "string", "title": "First name"},
          "lastName": {"type": "string", "title": "Last name"},
          "age": {"type": "integer", "title": "Age"},
        },
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DjsfForm(schema: schema))),
      );

      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ReactiveTextField<String>, "First name"),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(ReactiveTextField<String>, "Last name"),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(ReactiveTextField<int>, "Age"),
        findsOneWidget,
      );
    });

    testWidgets('applies default value from schema to string field',
        (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "firstName": {
            "type": "string",
            "title": "First name",
            "default": "Chuck",
          },
        },
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DjsfForm(schema: schema))),
      );

      await tester.pumpAndSettle();

      // The text "Chuck" should appear as the field's initial value
      expect(find.text('Chuck'), findsOneWidget);
    });

    testWidgets('applies default value from schema to integer field',
        (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "age": {"type": "integer", "title": "Age", "default": 42},
        },
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DjsfForm(schema: schema))),
      );

      await tester.pumpAndSettle();

      // Integer defaults are rendered as text in the input
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('formData overrides schema default (string)', (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "firstName": {
            "type": "string",
            "title": "First name",
            "default": "Chuck",
          },
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(
              schema: schema,
              formData: {"firstName": "Bruce"},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show the override, not the default
      expect(find.text('Bruce'), findsOneWidget);
      expect(find.text('Chuck'), findsNothing);
    });

    testWidgets('falls back to empty when no default and no formData',
        (tester) async {
      final schema = {
        "title": "Test form",
        "properties": {
          "nickname": {"type": "string", "title": "Nickname"},
        },
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DjsfForm(schema: schema))),
      );

      await tester.pumpAndSettle();

      // No default or formData → no prefilled text (label still exists, but no value)
      expect(find.text('Nickname'), findsOneWidget);
      // Ensure there's no stray value shown
      expect(find.text('Chuck'), findsNothing);
      expect(find.text('Bruce'), findsNothing);
    });
  });
}

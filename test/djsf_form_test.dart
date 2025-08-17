import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

void main() {
  group('DjsfForm', () {
    testWidgets('renders the schema title as text',
        (WidgetTester tester) async {
      // Arrange
      final schema = {
        "title": "A registration form",
        "type": "object",
        "properties": {
          "firstName": {"type": "string"}
        }
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(schema: schema),
          ),
        ),
      );

      // Assert
      expect(find.text("A registration form"), findsOneWidget);
    });

    testWidgets('renders placeholder text if no title is provided',
        (WidgetTester tester) async {
      // Arrange
      final schema = {
        "type": "object",
        "properties": {
          "firstName": {"type": "string"}
        }
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DjsfForm(schema: schema),
          ),
        ),
      );

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

      expect(find.text('Register users'), findsNothing);
    });
  });
}

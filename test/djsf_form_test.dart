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
}

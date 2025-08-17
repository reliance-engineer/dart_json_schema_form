import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:example/examples/very_simple_form_example.dart';

void main() {
  testWidgets(
    'VerySimpleFormExample renders title, description, and the form field',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: VerySimpleFormExample()));

      // App bar title
      expect(find.text('DJSF Very Simple Example'), findsOneWidget);

      // Schema title & description
      expect(find.text('A registration form'), findsOneWidget);
      expect(find.text('Register users'), findsOneWidget);

      // Field from schema.properties.firstName
      // Since properties.firstName has no "title", the label defaults to the key name: "firstName"
      expect(
        find.widgetWithText(ReactiveTextField<String>, 'firstName'),
        findsOneWidget,
      );
    },
  );
}

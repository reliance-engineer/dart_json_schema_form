import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/examples/validation_messages_example.dart';

void main() {
  group('ValidationMessagesExample', () {
    testWidgets(
      'renders and shows default + custom messages via transformErrors',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: ValidationMessagesExample()),
        );

        await tester.pumpAndSettle();

        // App bar
        expect(find.text('DJSF Validation messages'), findsOneWidget);

        // Field labels
        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Age'), findsOneWidget);

        // 1) Submit empty → required for email (default message)
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(find.text('This field is required'), findsOneWidget);

        // 2) Full Name too short (minLength: 5) → default minLength message
        // TextField order (by creation): 0 Full Name, 1 Email, 2 Age
        await tester.enterText(find.byType(TextField).at(0), 'Ana'); // length 3
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(find.text('Must be at least 5 characters'), findsOneWidget);

        // 3) Email wrong pattern → custom transformErrors message
        await tester.enterText(find.byType(TextField).at(1), 'nope');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(
          find.text('Custom message: Please enter a valid email address'),
          findsOneWidget,
        );

        // 4) Age below minimum (min: 18) → custom transformErrors message
        await tester.enterText(find.byType(TextField).at(2), '16');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(
          find.text('Custom message: Must be at least 18 years old'),
          findsOneWidget,
        );

        // (Optional) Fix values → errors disappear
        await tester.enterText(
          find.byType(TextField).at(0),
          'Alice Doe',
        ); // >= 5
        await tester.enterText(
          find.byType(TextField).at(1),
          'user@example.com',
        );
        await tester.enterText(find.byType(TextField).at(2), '21');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        expect(find.text('Must be at least 5 characters'), findsNothing);
        expect(
          find.text('Custom message: Please enter a valid email address'),
          findsNothing,
        );
        expect(
          find.text('Custom message: Must be at least 18 years old'),
          findsNothing,
        );
      },
    );
  });
}

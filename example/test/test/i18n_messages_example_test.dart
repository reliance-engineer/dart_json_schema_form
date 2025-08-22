import 'package:example/examples/l18n_messages_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('L18nMessagesExample', () {
    testWidgets('renders and switches required message between EN and ES', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: L18nMessagesExample()));

      await tester.pumpAndSettle();

      // App bar
      expect(find.text('DJSF Internationalization Example'), findsOneWidget);

      // Language buttons exist
      for (final code in languages) {
        expect(find.text(code.toUpperCase()), findsWidgets);
      }

      // Start in English (default 'en')
      // Submit empty form → should show English required message
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('This field is required'), findsOneWidget);

      // Switch to ES
      await tester.tap(find.text('ES'));
      await tester.pumpAndSettle();

      // Submit again → should show Spanish required message
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Este campo es obligatorio'), findsOneWidget);
    });

    testWidgets('switches to DE and shows the German required message', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: L18nMessagesExample()));

      // Switch to DE
      await tester.tap(find.text('DE'));
      await tester.pumpAndSettle();

      // Submit empty form → should show German required message
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Dieses Feld ist erforderlich'), findsOneWidget);
    });
  });
}

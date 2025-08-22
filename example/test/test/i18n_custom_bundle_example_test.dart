import 'package:example/examples/l18n_custom_bundle_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('L18nMessagesExample', () {
    testWidgets(
      'renders and switches required message between EN and ES shows custom message',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: L18nCustomBundlesExample()),
        );

        await tester.pumpAndSettle();

        // App bar
        expect(
          find.text('DJSF Custom Internationalization Example'),
          findsOneWidget,
        );

        // Language buttons exist
        for (final code in languages) {
          expect(find.text(code.toUpperCase()), findsWidgets);
        }

        // Start in English (default 'en')
        // Submit empty form → should show English required message
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(find.text('My custom required message'), findsOneWidget);

        // Switch to ES
        await tester.tap(find.text('ES'));
        await tester.pumpAndSettle();

        // Submit again → should show Spanish required message
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        expect(find.text('My custom required message'), findsOneWidget);
      },
    );
  });
}

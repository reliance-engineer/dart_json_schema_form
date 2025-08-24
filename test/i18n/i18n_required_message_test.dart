// example/test/i18n_required_message_test.dart
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/generated/l10n.dart' as djsf_l10n;
import 'package:dart_json_schema_form/src/i18n/bundles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Build a test app with a schema that exercises ALL validators.
Widget _app(Locale locale) {
  final schema = {
    "title": "Form",
    // Make a real required field
    "required": ["requiredMessage"],
    "properties": {
      "requiredMessage": {"type": "string", "title": "Required Field"},
      "minLengthMessage": {
        "type": "string",
        "title": "Min Length Field",
        "minLength": 5
      },
      "maxLengthMessage": {
        "type": "string",
        "title": "Max Length Field",
        "maxLength": 5
      },
      "minimumMessage": {
        "type": "integer",
        "title": "Minimum Field",
        "minimum": 2
      },
      "maximumMessage": {
        "type": "integer",
        "title": "Maximum Field",
        "maximum": 2
      },
      "patternMessage": {
        "type": "string",
        "title": "Pattern Field",
        "pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$",
      },
      "equalsMessage": {
        "type": "integer",
        "title": "Equals Field",
        // our parser supports JSON Schema 'const'
        "const": 2,
      },
    },
  };

  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      djsf_l10n.S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: djsf_l10n.S.delegate.supportedLocales,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: DjsfForm(
          schema: schema,
          messagesBundle: const IntlBundle(),
        ),
      ),
    ),
  );
}

/// Helper: find the TextField whose decoration.labelText == [label]
Future<Finder> _textFieldByLabel(WidgetTester tester, String label) async {
  final finder = find.byWidgetPredicate(
    (w) => w is TextField && (w.decoration?.labelText == label),
    description: 'TextField(labelText="$label")',
  );
  await tester.ensureVisible(finder);
  return finder;
}

Future<void> tapButton(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Submit'));
  await tester.tap(find.text('Submit'));
}

void main() {
  group('IntlBundle validation messages', () {
    Future<void> runAllValidatorAssertions(
      WidgetTester tester, {
      required Locale locale,
      required String requiredMsg,
      required String minLengthMsg5,
      required String maxLengthMsg5,
      required String patternMsg,
      required String minMsg2,
      required String maxMsg2,
      required String equalsMsg2,
    }) async {
      await tester.pumpWidget(_app(locale));
      await tester.pumpAndSettle();

      // 1) REQUIRED (Required Field): press submit to show message
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(requiredMsg), findsOneWidget);

      // 2) MIN LENGTH (Min Length Field, minLength=5): enter "abc" (3 chars)
      await tester.enterText(
          await _textFieldByLabel(tester, 'Min Length Field'), 'abc');
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(minLengthMsg5), findsOneWidget);

      // 3) MAX LENGTH (Max Length Field, maxLength=5): enter 10 chars
      await tester.enterText(
          await _textFieldByLabel(tester, 'Max Length Field'), 'abcdefghij');
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(maxLengthMsg5), findsOneWidget);

      // 4) PATTERN (Pattern Field expects email): enter "nope"
      await tester.enterText(
          await _textFieldByLabel(tester, 'Pattern Field'), 'nope');
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(patternMsg), findsOneWidget);

      // 5) MINIMUM (Minimum Field, minimum=2): enter "1"
      await tester.enterText(
          await _textFieldByLabel(tester, 'Minimum Field'), '1');
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(minMsg2), findsOneWidget);

      // 6) MAXIMUM (Maximum Field, maximum=2): enter "3"
      await tester.enterText(
          await _textFieldByLabel(tester, 'Maximum Field'), '3');
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(maxMsg2), findsOneWidget);

      // 7) CONST/EQUALS (Equals Field, const=2): enter "4"
      await tester.enterText(
          await _textFieldByLabel(tester, 'Equals Field'), '4');
      await tapButton(tester);
      await tester.pumpAndSettle();
      expect(find.text(equalsMsg2), findsOneWidget);
    }

    testWidgets('shows all validator messages in English', (tester) async {
      await runAllValidatorAssertions(
        tester,
        locale: const Locale('en'),
        requiredMsg: 'This field is required',
        minLengthMsg5: 'Must be at least 5 characters',
        maxLengthMsg5: 'Must be at most 5 characters',
        patternMsg: 'Invalid format',
        minMsg2: 'Must be ≥ 2',
        maxMsg2: 'Must be ≤ 2',
        equalsMsg2: 'Must equal 2',
      );
    });

    testWidgets('shows all validator messages in Spanish', (tester) async {
      await runAllValidatorAssertions(
        tester,
        locale: const Locale('es'),
        requiredMsg: 'Este campo es obligatorio',
        minLengthMsg5: 'Debe tener al menos 5 caracteres',
        maxLengthMsg5: 'Debe tener como máximo 5 caracteres',
        patternMsg: 'Formato inválido',
        minMsg2: 'Debe ser ≥ 2',
        maxMsg2: 'Debe ser ≤ 2',
        equalsMsg2: 'Debe ser igual a 2',
      );
    });
  });
}

// example/test/i18n_required_message_test.dart
import 'package:dart_json_schema_form/src/i18n/bundles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/generated/l10n.dart' as djsf_l10n;

Widget _app(Locale locale) {
  final schema = {
    "title": "Form",
    "required": ["username"],
    "properties": {
      "username": {"type": "string", "title": "Username", "minLength": 5},
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
      body: DjsfForm(
        schema: schema,
        messagesBundle: IntlBundle(),
      ),
    ),
  );
}

void main() {
  testWidgets('required message shows in English', (tester) async {
    await tester.pumpWidget(_app(const Locale('en')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // From intl_en.arb
    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('required message shows in Spanish', (tester) async {
    await tester.pumpWidget(_app(const Locale('es')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // From intl_es.arb
    expect(find.text('Este campo es obligatorio'), findsOneWidget);
  });
}

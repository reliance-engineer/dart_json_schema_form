import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/generated/l10n.dart' as djsf_l10n;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('array of strings shows inputs and Add works', (tester) async {
    final schema = {
      "title": "Tags",
      "type": "object",
      "properties": {
        "tags": {
          "type": "array",
          "title": "Tags",
          "items": {"type": "string", "title": "Tag"},
          "minItems": 1,
        },
      },
    };

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          djsf_l10n.S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: DjsfForm(
            schema: schema,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsWidgets);

    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    final count = tester.widgetList<TextField>(find.byType(TextField)).length;
    expect(count, greaterThanOrEqualTo(2));
  });
}

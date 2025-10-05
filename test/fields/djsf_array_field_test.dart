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

    expect(find.byType(TextField), findsOneWidget);

    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('delete buttons remove item in index', (tester) async {
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

    final data = {
      "tags": ["foo", "bar", "tar"],
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
            formData: data,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(3));

    await tester.tap(find.text('Remove').first);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Can not add or remove items in fixed array list',
      (tester) async {
    final schema = {
      "title": "Tags",
      "type": "object",
      "properties": {
        "tags": {
          "type": "array",
          "title": "Tags",
          "items": [
            {"type": "string", "title": "Tag", "default": "foo"},
            {"type": "string", "title": "Tag", "default": "bar"},
          ],
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

    expect(find.byType(TextField), findsNWidgets(2));

    expect(find.text('Add item'), findsNothing);
    expect(find.text('Remove'), findsNothing);
  });

  testWidgets('array of objects shows inputs and Add works', (tester) async {
    final schema = {
      "title": "Tags",
      "type": "object",
      "properties": {
        "tags": {
          "type": "array",
          "title": "Tags",
          "items": {
            "type": "object",
            "title": "Tag",
            "properties": {
              "name": {
                "type": "string",
                "title": "Name",
                "default": "foo",
              },
              "age": {
                "type": "integer",
                "title": "Age",
                "default": "10",
              },
            },
          },
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

    expect(find.byType(TextField), findsNWidgets(2));

    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(4));
  });
}

import 'package:dart_json_schema_form/generated/l10n.dart' as djsf_l10n;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'examples/array_simple_example.dart';
import 'examples/l18n_custom_bundle_example.dart';
import 'examples/l18n_messages_example.dart';
import 'examples/ui_schema_simple_example.dart';
import 'examples/validation_messages_example.dart';
import 'examples/very_simple_form_example.dart';

void main() {
  runApp(const MyApp());
}

final examples = <Map<String, String>>[
  {
    "title": VerySimpleFormExample.title,
    "description": VerySimpleFormExample.description,
    "route": VerySimpleFormExample.route,
  },
  {
    "title": ValidationMessagesExample.title,
    "description": ValidationMessagesExample.description,
    "route": ValidationMessagesExample.route,
  },
  {
    "title": L18nMessagesExample.title,
    "description": L18nMessagesExample.description,
    "route": L18nMessagesExample.route,
  },
  {
    "title": L18nCustomBundlesExample.title,
    "description": L18nCustomBundlesExample.description,
    "route": L18nCustomBundlesExample.route,
  },
  {
    "title": UiSchemaSimpleExample.title,
    "description": UiSchemaSimpleExample.description,
    "route": UiSchemaSimpleExample.route,
  },
  {
    "title": ArraySimpleExample.title,
    "description": ArraySimpleExample.description,
    "route": ArraySimpleExample.route,
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _appTitle = 'DJSF Examples';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(useMaterial3: true),
      home: const _HomePage(title: _appTitle),
      localizationsDelegates: const [
        djsf_l10n.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        VerySimpleFormExample.route: (_) => const VerySimpleFormExample(),
        ValidationMessagesExample.route:
            (_) => const ValidationMessagesExample(),
        L18nMessagesExample.route: (_) => const L18nMessagesExample(),
        L18nCustomBundlesExample.route: (_) => const L18nCustomBundlesExample(),
        UiSchemaSimpleExample.route: (_) => const UiSchemaSimpleExample(),
        ArraySimpleExample.route: (_) => const ArraySimpleExample(),
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: examples.length,
        itemBuilder: (_, index) {
          final item = examples[index];
          return ListTile(
            title: Text(item['title']!),
            subtitle: Text(item['description']!),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(item['route']!),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
      ),
    );
  }
}

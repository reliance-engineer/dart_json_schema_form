import 'package:dart_json_schema_form/generated/l10n.dart' as djsf_l10n;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'examples/l18n_custom_bundle_example.dart';
import 'examples/l18n_messages_example.dart';
import 'examples/validation_messages_example.dart';
import 'examples/very_simple_form_example.dart';

void main() {
  runApp(const MyApp());
}

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
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Botón de navegación a tu ejemplo
          ListTile(
            title: const Text('Very simple form'),
            subtitle: const Text('Minimal example with title & description'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.of(
                  context,
                ).pushNamed(VerySimpleFormExample.route),
          ),
          const Divider(),
          ListTile(
            title: const Text('Validation messages'),
            subtitle: const Text('Form validation with custom messages'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.of(
                  context,
                ).pushNamed(ValidationMessagesExample.route),
          ),
          const Divider(),
          ListTile(
            title: const Text('Internationalization Example'),
            subtitle: const Text(
              'Show validation messages in built-in languages',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () =>
                    Navigator.of(context).pushNamed(L18nMessagesExample.route),
          ),
          const Divider(),
          ListTile(
            title: const Text('Custom Internationalization Example'),
            subtitle: const Text(
              'Show custom translations for validation messages',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.of(
                  context,
                ).pushNamed(L18nCustomBundlesExample.route),
          ),
          const Divider(),
          // Here will come more examples.
        ],
      ),
    );
  }
}

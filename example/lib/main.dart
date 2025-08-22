import 'package:flutter/material.dart';
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
      routes: {
        VerySimpleFormExample.route: (_) => const VerySimpleFormExample(),
        ValidationMessagesExample.route:
            (_) => const ValidationMessagesExample(),
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
          // Here will come more examples.
        ],
      ),
    );
  }
}

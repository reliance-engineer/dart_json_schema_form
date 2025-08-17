import 'package:flutter/material.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final schema = {
      "title": "A registration form",
      "type": "object",
      "properties": {
        "firstName": {"type": "string"},
      },
    };
    final uiSchema = {
      "firstName": {"ui:autofocus": true},
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('DJSF Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: DjsfForm(schema: schema, uiSchema: uiSchema),
        ),
      ),
    );
  }
}

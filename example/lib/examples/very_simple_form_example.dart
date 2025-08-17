import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:flutter/material.dart';

final _schema = {
  "title": "A registration form",
  "description": "Register users",
  "type": "object",
  "properties": {
    "firstName": {"type": "string"},
  },
};
final _uiSchema = {
  "firstName": {"ui:autofocus": true},
};

class VerySimpleFormExample extends StatelessWidget {
  const VerySimpleFormExample({super.key});

  static const route = '/very-simple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DJSF Very Simple Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DjsfForm(schema: _schema, uiSchema: _uiSchema),
      ),
    );
  }
}

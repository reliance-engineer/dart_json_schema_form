import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:flutter/material.dart';

final _schema = {
  "title": "A registration form",
  "description": "A simple form example.",
  "type": "object",
  "required": ["firstName", "telephone"],
  "properties": {
    "firstName": {"type": "string", "title": "First name", "default": "Chuck"},
    "lastName": {"type": "string", "title": "Last name"},
    "age": {"type": "integer", "title": "Age", "minimum": 6},
    "bio": {"type": "string", "title": "Bio"},
    "password": {"type": "string", "title": "Password", "minLength": 3},
    "telephone": {"type": "string", "title": "Telephone", "minLength": 10},
  },
};

final _uiSchema = {
  "firstName": {
    "ui:autofocus": true,
    "ui:emptyValue": "",
    "ui:placeholder":
        "ui:emptyValue causes this field to always be valid despite being required",
    "ui:autocomplete": "family-name",
  },
  "lastName": {"ui:autocomplete": "given-name"},
  "age": {"ui:title": "Age of person", "ui:description": "(earth year)"},
  "bio": {"ui:widget": "textarea"},
  "password": {"ui:widget": "password", "ui:help": "Hint: Make it strong!"},
  "telephone": {
    "ui:options": {"inputType": "tel"},
  },
};

const languages = [
  'en',
  'es',
  'de',
  'it',
  'pt',
  'fr',
  'nl',
  'ja',
  'zh',
  'ru',
  'pl',
];

class UiSchemaSimpleExample extends StatefulWidget {
  static const route = '/simple-ui-example';

  const UiSchemaSimpleExample({super.key});

  @override
  State<UiSchemaSimpleExample> createState() => _UiSchemaSimpleExampleState();
}

class _UiSchemaSimpleExampleState extends State<UiSchemaSimpleExample> {
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DJSF UI Schema Simple Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: DjsfForm(
                  schema: _schema,
                  uiSchema: _uiSchema,
                  locale: language,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:flutter/material.dart';

final _schema = {
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
final _uiSchema = {
  "tags": {
    "ui:options": {"addButtonText": "Add tag", "removable": true},
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

class ArraySimpleExample extends StatefulWidget {
  const ArraySimpleExample({super.key});

  static const route = '/array-simple';
  static const title = 'Array simple Example';
  static const description = 'Simple example with Array field';

  @override
  State<ArraySimpleExample> createState() => _ArraySimpleExampleState();
}

class _ArraySimpleExampleState extends State<ArraySimpleExample> {
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ArraySimpleExample.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: languages.length,
                  shrinkWrap: true,
                  itemBuilder:
                      (context, i) => TextButton(
                        onPressed:
                            language != languages[i]
                                ? () {
                                  setState(() {
                                    language = languages[i];
                                  });
                                }
                                : null,
                        child: Text(languages[i].toUpperCase()),
                      ),
                ),
              ),
              Divider(height: 12),
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

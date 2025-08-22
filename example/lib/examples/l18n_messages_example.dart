import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:flutter/material.dart';

final _schema = {
  "title": "Sign up",
  "required": ["email"],
  "properties": {
    "firstName": {"type": "string", "title": "Full Name", "minLength": 5},
    "email": {
      "type": "string",
      "title": "Email",
      "pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$",
    },
    "age": {"type": "integer", "title": "Age", "minimum": 18},
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

class L18nMessagesExample extends StatefulWidget {
  static const route = '/l18n';

  const L18nMessagesExample({super.key});

  @override
  State<L18nMessagesExample> createState() => _L18nMessagesExampleState();
}

class _L18nMessagesExampleState extends State<L18nMessagesExample> {
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DJSF Internationalization Example')),
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
              Flexible(child: DjsfForm(schema: _schema, locale: language)),
            ],
          ),
        ),
      ),
    );
  }
}

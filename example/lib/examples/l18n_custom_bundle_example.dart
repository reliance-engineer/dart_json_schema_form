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

/// This is a custom bundle. It can modify the built-in message to return
/// a different text. This could be beneficial for example if you are using
/// a package for translations different tha Intl and you want to show your
/// own translations.
class MyCustomBundle extends DjsfMessageBundle {
  @override
  String equals(allowed) {
    return "My custom equals message $allowed";
  }

  @override
  String max(num limit) {
    return "My custom max message $limit";
  }

  @override
  String maxLength(int limit) {
    return "My custom maxLength message $limit";
  }

  @override
  String min(num limit) {
    return "My custom min message $limit";
  }

  @override
  String minLength(int limit) {
    return "My custom minLength message $limit";
  }

  @override
  String pattern() {
    return "My custom pattern message";
  }

  @override
  String required() {
    return "My custom required message";
  }
}

class L18nCustomBundlesExample extends StatefulWidget {
  static const route = '/custom_l18n';

  const L18nCustomBundlesExample({super.key});

  @override
  State<L18nCustomBundlesExample> createState() =>
      _L18nCustomBundlesExampleState();
}

class _L18nCustomBundlesExampleState extends State<L18nCustomBundlesExample> {
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DJSF Custom Internationalization Example'),
      ),
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

                  /// Here is set the custom translations bundle.
                  messagesBundle: MyCustomBundle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

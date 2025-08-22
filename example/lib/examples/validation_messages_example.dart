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

class ValidationMessagesExample extends StatelessWidget {
  static const route = '/validation';

  const ValidationMessagesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DJSF Very Simple Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DjsfForm(
          schema: _schema,
          transformErrors: (errors) {
            // Mutate messages conditionally (just like RJSF)
            return errors.map((e) {
              if (e.name == 'pattern' && e.property == '.email') {
                e.message =
                    'Custom message: Please enter a valid email address';
              }
              if (e.name == 'min' && e.property == '.age') {
                final limit = e.params?['limit'];
                e.message = 'Custom message: Must be at least $limit years old';
              }
              return e;
            }).toList();
          },
        ),
      ),
    );
  }
}

import 'package:dart_json_schema_form/src/parsers/schema_parser.dart';
import 'package:dart_json_schema_form/src/renderers/form_renderer.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'types/types.dart';

/// DJSF (Dart JSON Schema Form)
/// Entry point of the library.
/// Input: `schema` (RJSF-compatible) and `uiSchema`.
/// Currently only returns an empty placeholder widget.
class DjsfForm extends StatelessWidget {
  const DjsfForm({
    super.key,
    required this.schema,
    this.uiSchema,
    this.initialData,
    this.onChanged,
  });

  final JsonMap schema;
  final JsonMap? uiSchema;
  final JsonMap? initialData;
  final ValueChanged<JsonMap>? onChanged;

  @override
  Widget build(BuildContext context) {
    final String title = schema['title'] ?? 'DJSF Form Placeholder';
    final String? description = schema['description'];

    return ReactiveFormBuilder(
      form: () => SchemaParser.buildFormGroup(schema),
      builder: (context, form, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              if (description != null) Text(description),
              const SizedBox(height: 16),
              FormRenderer(form: form, schema: schema),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    debugPrint('Form value: ${form.value}');
                  } else {
                    form.markAllAsTouched();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}

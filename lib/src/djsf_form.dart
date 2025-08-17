import 'package:dart_json_schema_form/src/parsers/schema_parser.dart';
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

  /// JSON Schema following RJSF specification.
  final JsonMap schema;

  /// Optional UI Schema (RJSF).
  final JsonMap? uiSchema;

  /// Optional initial form values.
  final JsonMap? initialData;

  /// Optional callback to notify when form data changes.
  final ValueChanged<JsonMap>? onChanged;

  @override
  Widget build(BuildContext context) {
    final String title = schema['title'] ?? 'DJSF Form Placeholder';
    final String? description = schema['description'];
    return ReactiveFormBuilder(
      form: () => SchemaParser.buildFormGroup(schema),
      builder: (context, form, child) {
        return Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(),
            if (description != null) Text(description),
          ],
        );
      },
    );
  }
}

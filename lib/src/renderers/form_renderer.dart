import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../types/types.dart';

/// FormRenderer renders a list of form fields based on the schema and FormGroup.
class FormRenderer extends StatelessWidget {
  const FormRenderer({
    super.key,
    required this.form,
    required this.schema,
  });

  final FormGroup form;
  final JsonMap schema;

  @override
  Widget build(BuildContext context) {
    final rawProps = schema['properties'];

    // Ensure properties exist and are valid
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return SizedBox.shrink();
    }

    final properties = Map<String, dynamic>.from(rawProps);

    return Column(
      children: form.controls.entries.map((entry) {
        final name = entry.key;
        final control = entry.value;
        final propSchema = properties[name] as JsonMap? ?? {};

        return _buildField(name, control, propSchema);
      }).toList(),
    );
  }

  Widget _buildField(String name, AbstractControl control, JsonMap propSchema) {
    final type = propSchema['type'] as String? ?? 'string';
    final title = propSchema['title'] as String? ?? name;

    switch (type) {
      case 'integer':
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ReactiveTextField<int>(
            formControlName: name,
            decoration: InputDecoration(labelText: title),
            keyboardType: TextInputType.number,
          ),
        );
      case 'string':
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ReactiveTextField<String>(
            formControlName: name,
            decoration: InputDecoration(labelText: title),
          ),
        );
    }
  }
}

import 'dart:convert';

import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/fields/defaults.dart';
import 'package:dart_json_schema_form/src/i18n/bundles.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FormRenderer renders a list of form fields based on the schema and FormGroup.
class FormRenderer extends StatelessWidget {
  const FormRenderer({
    required this.form,
    required this.schema,
    this.uiSchema,
    super.key,
    this.messages = const IntlBundle(),
    this.transformErrors,
    this.fieldRegistry,
  });

  final FormGroup form;
  final JsonMap schema;
  final JsonMap? uiSchema;
  final DjsfMessageBundle messages;
  final TransformErrors? transformErrors;
  final DjsfFieldRegistry? fieldRegistry;

  @override
  Widget build(BuildContext context) {
    final rawProps = schema['properties'];
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return const SizedBox.shrink();
    }
    final properties = Map<String, dynamic>.from(rawProps);
    final registry = fieldRegistry ?? defaultFieldRegistry();

    return Column(
      children: form.controls.entries.map((entry) {
        final name = entry.key;
        final propSchema = properties[name] as JsonMap? ?? {};
        return _buildWithRegistry(name, propSchema, registry);
      }).toList(),
    );
  }

  Widget _buildWithRegistry(
    String name,
    JsonMap propSchema,
    DjsfFieldRegistry registry,
  ) {
    final type = (propSchema['type'] as String?) ?? 'string';
    final ui = uiSchema?[name] as JsonMap? ?? {};
    final modifier = (ui['ui:options'] as JsonMap?)?['inputType'] as String?;
    final widgetKey = modifier ?? (ui['ui:widget'] as String?) ?? type;

    debugPrint("Building $name with type $type and widgetKey $widgetKey");
    debugPrint("Building with uiSchema: ${jsonEncode(ui)}");

    final ctx = DjsfFieldContext(
      type: widgetKey,
      form: form,
      schema: schema,
      uiSchema: uiSchema,
      path: name,
      propSchema: propSchema,
      messages: messages,
      transformErrors: transformErrors,
    );

    final builder = registry[widgetKey] ?? registry[type] ?? registry['string'];

    if (builder == null) {
      return const SizedBox.shrink();
    }

    final field = builder(ctx);

    // Wrap with padding or field container if desired
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: field,
    );
  }
}

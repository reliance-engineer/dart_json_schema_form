import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/containers/containers.dart';
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
    this.containerRegistry,
    this.sectionTitle,
  });

  final FormGroup form;
  final JsonMap schema;
  final JsonMap? uiSchema;
  final DjsfMessageBundle messages;
  final TransformErrors? transformErrors;
  final DjsfFieldRegistry? fieldRegistry;
  final DjsfContainerRegistry? containerRegistry; // NEW
  final String? sectionTitle;

  @override
  Widget build(BuildContext context) {
    final rawProps = schema['properties'];
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return const SizedBox.shrink();
    }

    final properties = Map<String, dynamic>.from(rawProps);
    final fields = fieldRegistry ?? defaultFieldRegistry();
    final containers = containerRegistry ?? defaultContainerRegistry(); // NEW

    final children = <Widget>[
      if (sectionTitle != null) ...[
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            sectionTitle!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 16),
      ],
    ];

    for (final entry in form.controls.entries) {
      final name = entry.key;
      final control = entry.value;
      final propSchema = properties[name] as JsonMap? ?? {};
      final fieldUi = (uiSchema?[name] as JsonMap?) ?? const {};

      if (control is FormGroup) {
        // nested object → recurse
        final title = (propSchema['title'] as String?) ?? name;
        children.add(
          FormRenderer(
            form: control,
            schema: propSchema,
            uiSchema: (fieldUi['items'] is Map) // si vino desde arrays
                ? Map<String, dynamic>.from(fieldUi['items'] as Map)
                : fieldUi,
            messages: messages,
            transformErrors: transformErrors,
            fieldRegistry: fields,
            containerRegistry: containers,
            // keep passing it down
            sectionTitle: title,
          ),
        );
        continue;
      }

      if (control is FormArray) {
        // ARRAY → delega al containerRegistry
        final ctx = DjsfArrayContext(
          control: control,
          arraySchema: propSchema,
          arrayUiSchema: fieldUi,
          messages: messages,
          transformErrors: transformErrors,
          fieldRegistry: fields,
          fieldName: name,
          parentSchema: schema,
        );
        children.add(containers.arrayBuilder(ctx));
        continue;
      }

      children.add(
        buildWithRegistry(
          name,
          propSchema,
          fields,
          schema: schema,
          control: form.control(name),
          uiSchema: uiSchema,
          messages: messages,
          transformErrors: transformErrors,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  static Widget buildWithRegistry(
    String name,
    JsonMap propSchema,
    DjsfFieldRegistry registry, {
    required JsonMap schema,
    required AbstractControl<dynamic> control,
    JsonMap? uiSchema,
    DjsfMessageBundle messages = const IntlBundle(),
    TransformErrors? transformErrors,
  }) {
    final type = (propSchema['type'] as String?) ?? 'string';
    final ui = uiSchema?[name] as JsonMap? ?? {};
    final modifier = (ui['ui:options'] as JsonMap?)?['inputType'] as String?;
    final widgetKey = modifier ?? (ui['ui:widget'] as String?) ?? type;

    final ctx = DjsfFieldContext(
      type: widgetKey,
      control: control,
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

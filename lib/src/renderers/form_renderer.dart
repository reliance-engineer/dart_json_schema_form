import 'package:dart_json_schema_form/src/i18n/bundles.dart';
import 'package:dart_json_schema_form/src/types/djsf_error.dart';
import 'package:dart_json_schema_form/src/types/types.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FormRenderer renders a list of form fields based on the schema and FormGroup.
class FormRenderer extends StatelessWidget {
  const FormRenderer({
    required this.form,
    required this.schema,
    super.key,
    this.transformErrors,
    this.messages = const IntlBundle(),
  });

  final FormGroup form;
  final JsonMap schema;
  final TransformErrors? transformErrors;
  final DjsfMessageBundle messages;

  @override
  Widget build(BuildContext context) {
    final rawProps = schema['properties'];

    // Ensure properties exist and are valid
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return const SizedBox.shrink();
    }

    final properties = Map<String, dynamic>.from(rawProps);

    return Column(
      children: form.controls.entries.map((entry) {
        final name = entry.key;
        final propSchema = properties[name] as JsonMap? ?? {};
        return _buildField(name, propSchema);
      }).toList(),
    );
  }

  Widget _buildField(String name, JsonMap propSchema) {
    final type = (propSchema['type'] as String?) ?? 'string';
    final title = (propSchema['title'] as String?) ?? name;

    switch (type) {
      case 'integer':
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReactiveTextField<int>(
            formControlName: name,
            decoration: InputDecoration(labelText: title),
            keyboardType: TextInputType.number,
            validationMessages: _messagesForField(name, propSchema),
          ),
        );
      case 'string':
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReactiveTextField<String>(
            formControlName: name,
            decoration: InputDecoration(labelText: title),
            validationMessages: _messagesForField(name, propSchema),
          ),
        );
    }
  }

  /// Build messages for one field.
  /// Returns a Map of validatorKey → ValidationMessageFunction
  Map<String, ValidationMessageFunction> _messagesForField(
    String fieldName,
    JsonMap propSchema,
  ) {
    return {
      ValidationMessage.required: (error) {
        return _transformSingleError(
          fieldName,
          'required',
          messages.required(),
          propSchema,
        );
      },
      ValidationMessage.minLength: (error) {
        final limit = (propSchema['minLength'] is int)
            ? propSchema['minLength'] as int
            : 0;
        return _transformSingleError(
          fieldName,
          'minLength',
          messages.minLength(limit),
          propSchema,
          params: {'limit': limit},
        );
      },
      ValidationMessage.maxLength: (error) {
        final limit = (propSchema['maxLength'] is int)
            ? propSchema['maxLength'] as int
            : 0;
        return _transformSingleError(
          fieldName,
          'maxLength',
          messages.maxLength(limit),
          propSchema,
          params: {'limit': limit},
        );
      },
      ValidationMessage.pattern: (error) {
        return _transformSingleError(
          fieldName,
          'pattern',
          messages.pattern(),
          propSchema,
          params: {'pattern': propSchema['pattern']},
        );
      },
      ValidationMessage.min: (error) {
        final limit = propSchema['minimum'];
        final numLimit = (limit is num) ? limit : num.tryParse('$limit');
        return _transformSingleError(
          fieldName,
          'min',
          messages.min(numLimit ?? 0),
          propSchema,
          params: {'limit': numLimit},
        );
      },
      ValidationMessage.max: (error) {
        final limit = propSchema['maximum'];
        final numLimit = (limit is num) ? limit : num.tryParse('$limit');
        return _transformSingleError(
          fieldName,
          'max',
          messages.max(numLimit ?? 0),
          propSchema,
          params: {'limit': numLimit},
        );
      },
      ValidationMessage.equals: (error) {
        final allowed = propSchema['const'];
        return _transformSingleError(
          fieldName,
          'equals',
          messages.equals(allowed),
          propSchema,
          params: {'allowed': allowed},
        );
      },
    };
  }

  /// Apply transformErrors if provided
  String _transformSingleError(
    String fieldName,
    String name,
    String defaultMessage,
    JsonMap propSchema, {
    Map<String, Object?>? params,
  }) {
    final error = DjsfError(
      name: name,
      property: '.$fieldName',
      message: defaultMessage,
      params: params,
    );

    if (transformErrors != null) {
      final transformed = transformErrors!([error]);
      if (transformed.isNotEmpty) {
        return transformed.first.message;
      }
    }
    return defaultMessage;
  }
}

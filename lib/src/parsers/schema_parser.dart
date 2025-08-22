import 'package:reactive_forms/reactive_forms.dart';
import '../types/types.dart';

/// Utility class that converts JSON Schema into a Reactive Forms FormGroup.
class SchemaParser {
  /// Builds a FormGroup from the given JSON Schema.
  /// - Each property becomes a typed FormControl.
  /// - Initial value comes from `formData` > schema `default` > null.
  /// - Validators supported: `required`, `minLength`, `maxLength` (string fields).
  static FormGroup buildFormGroup(
    JsonMap schema, {
    JsonMap? formData,
  }) {
    final rawProps = schema['properties'];

    // Ensure properties exist and are valid
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return FormGroup({});
    }

    final properties = Map<String, dynamic>.from(rawProps);

    // Collect required fields from root-level "required": [...]
    final requiredList = (schema['required'] is List)
        ? List<String>.from(schema['required'] as List)
        : const <String>[];
    final requiredSet = requiredList.toSet();

    final controls = <String, AbstractControl>{};

    for (final entry in properties.entries) {
      final name = entry.key;
      final propSchema = _asMap(entry.value);

      final initialValue = _resolveInitialValue(name, propSchema, formData);

      final validators = _buildValidators(
        propSchema,
        isRequired: requiredSet.contains(name),
      );

      controls[name] = _buildTypedControl(propSchema, initialValue, validators);
    }

    return FormGroup(controls);
  }

  /// Resolve initial value by priority: formData > schema.default > null.
  static dynamic _resolveInitialValue(
    String name,
    JsonMap propSchema,
    JsonMap? formData,
  ) {
    if (formData != null && formData.containsKey(name)) {
      return formData[name];
    }
    if (propSchema.containsKey('default')) {
      return propSchema['default'];
    }
    return null;
  }

  /// Build validators for a property.
  /// Currently supports:
  /// - required (from root "required" array)
  /// - minLength / maxLength for string fields (JSON Schema keywords)
  static List<Validator<dynamic>> _buildValidators(
    JsonMap propSchema, {
    required bool isRequired,
  }) {
    final type = (propSchema['type'] as String?)?.toLowerCase();
    final validators = <Validator<dynamic>>[];

    if (isRequired) {
      validators.add(Validators.required);
    }

    if (propSchema.containsKey('const')) {
      validators.add(Validators.equals(propSchema['const']));
    }

    if (type == 'string') {
      final minLength = propSchema['minLength'];
      final maxLength = propSchema['maxLength'];
      final pattern = propSchema['pattern'];

      if (minLength is int) {
        validators.add(Validators.minLength(minLength));
      }
      if (maxLength is int) {
        validators.add(Validators.maxLength(maxLength));
      }
      if (pattern is String && pattern.isNotEmpty) {
        validators.add(Validators.pattern(RegExp(pattern)));
      }
    }

    if (['integer', 'number'].contains(type)) {
      final min = num.tryParse(propSchema['minimum'].toString());
      final max = num.tryParse(propSchema['maximum'].toString());

      if (min != null) {
        validators.add(Validators.min(min));
      }
      if (max != null) {
        validators.add(Validators.max(max));
      }
    }

    return validators;
  }

  /// Create a typed control and attach validators.
  static AbstractControl _buildTypedControl(
    JsonMap propSchema,
    dynamic value,
    List<Validator<dynamic>> validators,
  ) {
    final type = (propSchema['type'] as String?)?.toLowerCase();

    switch (type) {
      case 'string':
        return FormControl<String>(
          value: value as String?,
          validators: validators,
        );
      case 'integer':
        return FormControl<int>(
          value: value is int ? value : null,
          validators: validators,
        );
      case 'number':
        return FormControl<double>(
          value: value is num ? value.toDouble() : null,
          validators: validators,
        );
      case 'boolean':
        return FormControl<bool>(
          value: value is bool ? value : null,
          validators: validators,
        );
      case 'object':
        return FormGroup({});
      case 'array':
        return FormArray([]);
      default:
        // Fallback to string
        return FormControl<String>(
          value: value?.toString(),
          validators: validators,
        );
    }
  }

  static JsonMap _asMap(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    return <String, dynamic>{};
  }
}

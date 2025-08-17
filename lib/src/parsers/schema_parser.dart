import 'package:reactive_forms/reactive_forms.dart';
import '../types/types.dart';

/// Utility class that converts JSON Schema into a Reactive Forms FormGroup.
class SchemaParser {
  /// Builds a FormGroup from the given JSON Schema.
  /// - Each property in the schema becomes a typed FormControl based on `type`.
  /// - Initial value is `null` for now.
  static FormGroup buildFormGroup(JsonMap schema, {JsonMap? formData}) {
    final rawProps = schema['properties'];

    // Ensure properties exist and are valid
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return FormGroup({});
    }

    final properties = Map<String, dynamic>.from(rawProps);
    final controls = <String, AbstractControl>{};

    for (final entry in properties.entries) {
      final name = entry.key;
      final propSchema = _asMap(entry.value);

      final initialValue = _resolveInitialValue(
        name,
        propSchema,
        formData,
      );

      controls[name] = _buildTypedControl(propSchema, initialValue);
    }

    return FormGroup(controls);
  }

  /// Picks value from formData > schema.default > null
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

  /// Create a typed FormControl based on the JSON Schema `type`.
  static AbstractControl _buildTypedControl(JsonMap propSchema, dynamic value) {
    final type = (propSchema['type'] as String?)?.toLowerCase();

    switch (type) {
      case 'string':
        return FormControl<String>(value: value as String?);
      case 'integer':
        return FormControl<int>(value: value is int ? value : null);
      case 'number':
        return FormControl<double>(
            value: value is num ? value.toDouble() : null);
      case 'boolean':
        return FormControl<bool>(value: value is bool ? value : null);
      case 'object':
        // Placeholder: nested objects will be another FormGroup (empty for now)
        return FormGroup({});
      case 'array':
        // Placeholder: arrays will be FormArray (empty for now)
        return FormArray([]);
      default:
        return FormControl<String>(value: value?.toString());
    }
  }

  /// Ensures value is always returned as a Map<String, dynamic>.
  static JsonMap _asMap(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    return <String, dynamic>{};
  }
}

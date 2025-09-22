import 'package:dart_json_schema_form/src/types/types.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
    final props = _asMap(schema['properties']);
    final requiredList = (schema['required'] is List)
        ? List<String>.from(schema['required'] as List)
        : const <String>[];
    final controls = <String, AbstractControl>{};

    props.forEach((key, propSchemaDyn) {
      final propSchema = _asMap(propSchemaDyn);
      final isRequired = requiredList.contains(key);
      final initial = _resolveInitialValue(key, propSchema, formData);

      controls[key] = _buildControlFromSchema(
        propSchema: propSchema,
        isRequired: isRequired,
        initialValue: initial,
      );
    });

    return FormGroup(controls);
  }

  static AbstractControl _buildControlFromSchema({
    required JsonMap propSchema,
    required bool isRequired,
    dynamic initialValue,
  }) {
    final type = (propSchema['type'] as String?) ?? 'string';

    switch (type) {
      case 'object':
        return _buildGroupForObject(propSchema, initialValue);

      case 'array':
        return _buildArrayForItems(propSchema, initialValue);

      case 'integer':
        return _buildLeafControl<int>(propSchema, isRequired, initialValue);
      case 'number':
        return _buildLeafControl<double>(propSchema, isRequired, initialValue);
      case 'boolean':
        return _buildLeafControl<bool>(propSchema, isRequired, initialValue);
      default:
        return _buildLeafControl<String>(
          propSchema,
          isRequired,
          initialValue?.toString(),
        );
    }
  }

  static FormGroup _buildGroupForObject(
    JsonMap objectSchema,
    dynamic initialValue,
  ) {
    final props = _asMap(objectSchema['properties']);
    final requiredList = (objectSchema['required'] is List)
        ? List<String>.from(objectSchema['required'] as List)
        : const <String>[];
    final mapInit = (initialValue is Map)
        ? Map<String, dynamic>.from(initialValue)
        : const <String, dynamic>{};

    final children = <String, AbstractControl>{};
    props.forEach((name, sch) {
      final propSchema = _asMap(sch);
      final isReq = requiredList.contains(name);
      children[name] = _buildControlFromSchema(
        propSchema: propSchema,
        isRequired: isReq,
        initialValue: mapInit[name] ??
            _resolveInitialValue(name, propSchema, initialValue),
      );
    });
    return FormGroup(children);
  }

  static FormArray _buildArrayForItems(
    JsonMap arraySchema,
    dynamic initialValue,
  ) {
    final itemsSchema = _asMap(
      arraySchema['items'],
    );

    final listInit = (initialValue is List)
        ? List<dynamic>.from(initialValue)
        : const <dynamic>[];
    final controls = <AbstractControl>[];

    for (var i = 0; i < listInit.length; i++) {
      controls.add(
        _buildControlFromSchema(
          propSchema: itemsSchema,
          isRequired: false,
          initialValue: listInit[i],
        ),
      );
    }

    final validators = <Validator<dynamic>>[];
    if (arraySchema['minItems'] is int) {
      final min = arraySchema['minItems'] as int;
      validators.add(
        DelegateValidator((control) {
          final v = control.value as List?;
          if (v == null) {
            return {
              'minItems': {'min': min},
            };
          }
          return v.length >= min
              ? null
              : {
                  'minItems': {'min': min},
                };
        }),
      );
    }
    if (arraySchema['maxItems'] is int) {
      final max = arraySchema['maxItems'] as int;
      validators.add(
        DelegateValidator((control) {
          final v = control.value as List?;
          if (v == null) return null; // vacío no viola max
          return v.length <= max
              ? null
              : {
                  'maxItems': {'max': max},
                };
        }),
      );
    }
    if (arraySchema['uniqueItems'] == true) {
      validators.add(
        DelegateValidator((control) {
          final v = control.value as List?;
          if (v == null) return null;
          final set = v.map((e) => e.toString()).toSet();
          return set.length == v.length ? null : {'uniqueItems': true};
        }),
      );
    }

    return FormArray(controls, validators: validators);
  }

  static AbstractControl _buildLeafControl<T>(
    JsonMap schema,
    bool isRequired,
    T? initialValue,
  ) {
    final validators = _buildValidators(
      schema,
      isRequired: isRequired,
    );

    return _buildTypedControl(schema, initialValue, validators);
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
      default:
        // Fallback to string
        return FormControl<String>(
          value: value?.toString(),
          validators: validators,
        );
    }
  }

  static Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    return const <String, dynamic>{};
  }
}

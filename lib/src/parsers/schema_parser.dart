import 'package:reactive_forms/reactive_forms.dart';
import '../types/types.dart';

/// Utility class that converts JSON Schema into a Reactive Forms FormGroup.
class SchemaParser {
  /// Builds a FormGroup from the given JSON Schema.
  /// - Each property in the schema becomes a FormControl.
  /// - Initial value is always `null` for now.
  static FormGroup buildFormGroup(JsonMap schema) {
    final rawProps = schema['properties'];

    // Ensure properties is a Map<String, dynamic>
    if (rawProps == null || rawProps is! Map || rawProps.isEmpty) {
      return FormGroup({});
    }

    final properties = Map<String, dynamic>.from(rawProps);

    final controls = <String, AbstractControl>{};

    for (final entry in properties.entries) {
      final key = entry.key;
      controls[key] = FormControl<dynamic>(value: null);
    }

    return FormGroup(controls);
  }
}

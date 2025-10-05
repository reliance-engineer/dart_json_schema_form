// lib/src/fields/context.dart
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/src/types/types.dart';

class DjsfFieldContext {
  DjsfFieldContext({
    required this.type,
    required this.control,
    required this.schema,
    required this.path,
    required this.propSchema,
    required this.messages,
    this.uiSchema,
    this.transformErrors,
  });

  final String type;
  final AbstractControl<dynamic> control;
  final JsonMap schema;
  final JsonMap? uiSchema;
  final String path;
  final JsonMap propSchema;
  final DjsfMessageBundle messages;
  final TransformErrors? transformErrors;
}

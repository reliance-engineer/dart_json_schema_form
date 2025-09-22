// lib/src/fields/context.dart
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DjsfArrayContext {
  DjsfArrayContext({
    required this.control,
    required this.arraySchema,
    required this.arrayUiSchema,
    required this.messages,
    required this.transformErrors,
    required this.fieldRegistry,
    required this.fieldName,
    required this.parentSchema,
  });

  final FormArray control;
  final JsonMap arraySchema;
  final JsonMap arrayUiSchema;
  final DjsfMessageBundle messages;
  final TransformErrors? transformErrors;
  final DjsfFieldRegistry fieldRegistry;

  final String fieldName;
  final JsonMap parentSchema;
}

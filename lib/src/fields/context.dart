// lib/src/fields/context.dart
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/src/types/types.dart';

class DjsfFieldContext {
  DjsfFieldContext({
    required this.form,
    required this.schema,
    required this.uiSchema,
    required this.path,
    required this.propSchema,
    required this.messages,
    required this.transformErrors,
  });

  final FormGroup form;
  final JsonMap schema;
  final JsonMap? uiSchema;
  final String path;
  final JsonMap propSchema;
  final DjsfMessageBundle messages;
  final TransformErrors? transformErrors;

  AbstractControl get control => form.control(path);
}

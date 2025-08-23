import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/types/djsf_error.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef JsonMap = Map<String, dynamic>;

typedef TransformErrors = List<DjsfError> Function(List<DjsfError> errors);

typedef DjsfFieldBuilder = ReactiveFormField Function(DjsfFieldContext ctx);

/// Contract for a message bundle (could be backed by Intl or simple maps).
abstract class DjsfMessageBundle {
  String required();
  String minLength(int limit);
  String maxLength(int limit);
  String pattern();
  String min(num limit);
  String max(num limit);
  String equals(dynamic allowed);
}

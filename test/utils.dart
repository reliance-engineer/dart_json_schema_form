import 'package:dart_json_schema_form/dart_json_schema_form.dart';

class FakeBundle implements DjsfMessageBundle {
  @override
  String equals(allowed) => 'eq';
  @override
  String max(num limit) => 'max';
  @override
  String min(num limit) => 'min';
  @override
  String maxLength(int limit) => 'maxlen';
  @override
  String minLength(int limit) => 'minlen';
  @override
  String pattern() => 'pattern';
  @override
  String required() => 'required';
}

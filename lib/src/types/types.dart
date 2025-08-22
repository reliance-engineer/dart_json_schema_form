import 'djsf_error.dart';

typedef JsonMap = Map<String, dynamic>;

typedef TransformErrors = List<DjsfError> Function(List<DjsfError> errors);

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

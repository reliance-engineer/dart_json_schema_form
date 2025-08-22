import 'package:dart_json_schema_form/generated/l10n.dart';
import 'package:dart_json_schema_form/src/types/types.dart';

/// Intl-based implementation of DjsfMessageBundle.
/// Requires that you generated localization code from .arb files.
class IntlBundle implements DjsfMessageBundle {
  const IntlBundle();

  @override
  String required() => S.current.required;

  @override
  String minLength(int limit) => S.current.minLength(limit);

  @override
  String maxLength(int limit) => S.current.maxLength(limit);

  @override
  String pattern() => S.current.pattern;

  @override
  String min(num limit) => S.current.min(limit);

  @override
  String max(num limit) => S.current.max(limit);

  @override
  String equals(dynamic allowed) => S.current.equals(allowed);
}

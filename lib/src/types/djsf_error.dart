/// One error item (loosely mirrors RJSF’s error object)
class DjsfError {
  DjsfError({
    required this.name, // e.g., 'required', 'minLength', 'pattern', 'min', 'max', 'equals'
    required this.property, // path of the field, e.g., '.firstName'
    required this.message, // user-facing message
    this.params, // keyword-specific params (minLength, maxLength, minimum, maximum, pattern, const, etc.)
  });

  final String name;
  final String property;
  String message;
  final Map<String, Object?>? params;
}

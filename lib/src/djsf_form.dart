import 'package:flutter/widgets.dart';

typedef JsonMap = Map<String, dynamic>;

/// DJSF (Dart JSON Schema Form)
/// Entry point of the library.
/// Input: `schema` (RJSF-compatible) and `uiSchema`.
/// Currently only returns an empty placeholder widget.
class DjsfForm extends StatelessWidget {
  const DjsfForm({
    super.key,
    required this.schema,
    this.uiSchema,
    this.initialData,
    this.onChanged,
  });

  /// JSON Schema following RJSF specification.
  final JsonMap schema;

  /// Optional UI Schema (RJSF).
  final JsonMap? uiSchema;

  /// Optional initial form values.
  final JsonMap? initialData;

  /// Optional callback to notify when form data changes.
  final ValueChanged<JsonMap>? onChanged;

  @override
  Widget build(BuildContext context) {
    final title = schema['title'] ?? 'DJSF Form Placeholder';
    return Text(title.toString());
  }
}

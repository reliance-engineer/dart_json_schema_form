import 'package:dart_json_schema_form/src/parsers/schema_parser.dart';
import 'package:dart_json_schema_form/src/renderers/form_renderer.dart';
import 'package:dart_json_schema_form/src/types/i18n.dart';
import 'package:dart_json_schema_form/src/types/types.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// DJSF (Dart JSON Schema Form)
/// Entry point of the library.
/// Input: `schema` (RJSF-compatible) and `uiSchema`.
/// Currently only returns an empty placeholder widget.
class DjsfForm extends StatelessWidget {
  /// Creates a DJSF form from a JSON Schema and (optionally) uiSchema.
  ///
  /// Localization:
  /// - You can pass [locale] (e.g., `'es'`, `'de'`) to select one of the built‑in
  ///   message bundles without depending on `intl`.
  /// - Or you can pass a custom [messagesBundle] (for example an Intl‑backed
  ///   implementation) to fully control validation messages.
  ///
  /// Precedence:
  /// - If both [messagesBundle] and [locale] are provided, **[messagesBundle]
  ///   takes precedence**.
  ///
  /// Example:
  /// ```dart
  /// /// Using a built-in bundle (no intl required):
  /// DjsfForm(schema: schema, locale: 'es');
  ///
  /// /// Using a custom (intl) bundle:
  /// DjsfForm(schema: schema, messagesBundle: IntlBundle());
  ///
  /// /// Global default for entire app (optional):
  /// DjsfConfig.init(locale: 'de'); /// or DjsfConfig.init(bundle: IntlBundle());
  /// ```
  const DjsfForm({
    required this.schema,
    super.key,
    this.uiSchema,
    this.formData,
    this.onChanged,
    this.locale,
    this.messagesBundle,
    this.transformErrors,

    /// RJSF-style hook
  });

  final JsonMap schema;
  final JsonMap? uiSchema;
  final JsonMap? formData;
  final ValueChanged<JsonMap>? onChanged;

  /// RJSF-style hook to transform validation errors programmatically.
  /// Receives a list of errors and should return a (possibly modified) list.
  final TransformErrors? transformErrors;

  /// Optional locale code (e.g., `'en'`, `'es'`, `'de'`, `'it'`, `'pt'`, `'fr'`,
  /// `'nl'`, `'ja'`, `'zh'`, `'ru'`, `'pl'`).
  ///
  /// When provided, DJSF uses the corresponding **built‑in** message bundle
  /// (no `intl` dependency required). This is a simple way to localize default
  /// validation messages.
  ///
  /// If [messagesBundle] is also provided, that custom bundle **overrides** this
  /// locale setting.
  final String? locale;

  /// Optional custom message bundle to produce validation messages for the
  /// supported validation error.
  ///
  /// **note:** If added custom validation rules are not supported by the built-in
  /// you should use [transformErrors] instead.
  ///
  /// Any custom bundle must implement the [DjsfMessageBundle] interface.
  /// Example:
  ///
  /// ```dart
  /// class MyCustomBundle extends DjsfMessageBundle {
  ///   @override
  ///   String equals(allowed) {
  ///     return "My custom equals message $allowed";
  ///   }
  ///
  ///   @override
  ///   String max(num limit) {
  ///     return "My custom max message $limit";
  ///   }
  ///
  ///   @override
  ///   String maxLength(int limit) {
  ///     return "My custom maxLength message $limit";
  ///   }
  ///
  ///   @override
  ///   String min(num limit) {
  ///     return "My custom min message $limit";
  ///   }
  ///
  ///   @override
  ///   String minLength(int limit) {
  ///     return "My custom minLength message $limit";
  ///   }
  ///
  ///   @override
  ///   String pattern() {
  ///     return "My custom pattern message";
  ///   }
  ///
  ///   @override
  ///   String required() {
  ///     return "My custom required message";
  ///   }
  /// }
  /// ```
  ///
  /// **Precedence:** when set, this bundle **takes priority** over [locale]
  /// and over any global default configured with `DjsfConfig.init(...)`.
  final DjsfMessageBundle? messagesBundle;

  @override
  Widget build(BuildContext context) {
    final String title = schema['title'] ?? 'DJSF Form Placeholder';
    final String? description = schema['description'];

    return FutureBuilder<DjsfMessageBundle>(
      future: DjsfConfig.resolve(locale: locale, bundle: messagesBundle),
      builder: (context, snap) {
        if (!snap.hasData) {
          return SizedBox.shrink();
        }

        assert(!snap.hasError, 'Error loading message bundle: ${snap.error}');

        return ReactiveFormBuilder(
          form: () => SchemaParser.buildFormGroup(schema, formData: formData),
          builder: (context, form, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Divider(),
                  if (description != null) Text(description),
                  const SizedBox(height: 16),
                  FormRenderer(
                    form: form,
                    schema: schema,
                    transformErrors: transformErrors, // pass through
                    messages: snap.data!,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (form.valid) {
                        debugPrint('Form value: ${form.value}');
                      } else {
                        form.markAllAsTouched();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

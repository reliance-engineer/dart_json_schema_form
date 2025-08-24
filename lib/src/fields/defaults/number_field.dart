import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/utils/shared_messages.dart';
import 'package:dart_json_schema_form/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DjsfNumberField<T extends num> extends ReactiveFormField<T, T> {
  final DjsfFieldContext ctx;
  final bool obscureText;
  final TextInputType? keyboardType;

  DjsfNumberField({
    required this.ctx,
    required super.formControlName,
    super.key,
    this.obscureText = false,
    this.keyboardType,
  }) : super(
          builder: (ReactiveFormFieldState<T, T> field) {
            final title = ctx.propSchema['title'] as String? ?? ctx.path;
            final ui = readUiFor(ctx);
            final decoration = inputDecorationFromUi(title, ui);
            final messages = messagesForField(ctx, ctx.path, ctx.propSchema);

            // TODO Support sliders and updowns

            return ReactiveTextField<T>(
              formControl: field.control,
              decoration: decoration,
              obscureText: obscureText,
              autofocus: ui.autofocus,
              keyboardType: keyboardType ?? ui.keyboardTypeForString(),
              autofillHints:
                  ui.autocomplete != null ? [ui.autocomplete!] : null,
              validationMessages: messages,
              onChanged: (control) {
                if ((control.value == null) && ui.emptyValue != null) {
                  control.updateValue(ui.emptyValue as T, emitEvent: false);
                }
              },
            );
          },
        );

  @override
  ReactiveFormFieldState<T, T> createState() => ReactiveFormFieldState<T, T>();
}

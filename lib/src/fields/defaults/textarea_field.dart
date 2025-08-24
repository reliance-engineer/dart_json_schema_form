import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/utils/shared_messages.dart';
import 'package:dart_json_schema_form/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DjsfTextAreaField extends ReactiveFormField<String, String> {
  final DjsfFieldContext ctx;
  final bool obscureText;
  final TextInputType? keyboardType;

  DjsfTextAreaField({
    required this.ctx,
    required super.formControlName,
    super.key,
    this.obscureText = false,
    this.keyboardType,
  }) : super(
          builder: (ReactiveFormFieldState<String, String> field) {
            final title = ctx.propSchema['title'] as String? ?? ctx.path;
            final ui = readUiFor(ctx);
            final decoration = inputDecorationFromUi(title, ui);
            final messages = messagesForField(ctx, ctx.path, ctx.propSchema);

            return ReactiveTextField<String>(
              formControl: field.control,
              decoration: decoration,
              obscureText: obscureText,
              autofocus: ui.autofocus,
              keyboardType: keyboardType ?? ui.keyboardTypeForString(),
              autofillHints:
                  ui.autocomplete != null ? [ui.autocomplete!] : null,
              validationMessages: messages,
              maxLines: 4,
              onChanged: (control) {
                if ((control.value == null) && ui.emptyValue != null) {
                  control.updateValue(
                    ui.emptyValue as String,
                    emitEvent: false,
                  );
                }
              },
            );
          },
        );

  @override
  ReactiveFormFieldState<String, String> createState() =>
      ReactiveFormFieldState<String, String>();
}

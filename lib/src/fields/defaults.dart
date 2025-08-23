import 'package:dart_json_schema_form/src/fields/context.dart';
import 'package:dart_json_schema_form/src/fields/defaults/number_field.dart';
import 'package:dart_json_schema_form/src/fields/defaults/text_field.dart';
import 'package:dart_json_schema_form/src/fields/defaults/textarea_field.dart';
import 'package:dart_json_schema_form/src/fields/registry.dart';
import 'package:dart_json_schema_form/src/utils/shared_messages.dart';
import 'package:dart_json_schema_form/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

DjsfFieldRegistry defaultFieldRegistry() => DjsfFieldRegistry({
      'string': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.text,
          ),
      'text': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.text,
          ),
      'integer': (ctx) => DjsfNumberField<int>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.text,
          ),
      'number': (ctx) => DjsfNumberField<num>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.text,
          ),
      'password': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
      'textarea': (ctx) => DjsfTextAreaField(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.text,
          ),
      'tel': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.phone,
            obscureText: true,
          ),
      'email': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
          ),
    });

ReactiveFormField _textField(
  DjsfFieldContext ctx, {
  bool obscureText = false,
  TextInputType? keyboardType,
}) {
  final name = ctx.path;
  final title = ctx.propSchema['title'] as String? ?? name;
  final ui = readUiFor(ctx.uiSchema, name);
  final decoration = inputDecorationFromUi(title, ui);
  final messages = messagesForField(ctx, name, ctx.propSchema);

  return ReactiveTextField<String>(
    formControlName: name,
    decoration: decoration,
    obscureText: obscureText,
    autofocus: ui.autofocus,
    keyboardType: keyboardType ?? ui.keyboardTypeForString(),
    autofillHints: ui.autocomplete != null ? [ui.autocomplete!] : null,
    validationMessages: messages,
    onChanged: (control) {
      if ((control.value == null || control.value!.isEmpty) &&
          ui.emptyValue != null) {
        control.value = ui.emptyValue as String?;
      }
    },
  );
}

ReactiveFormField _intField(DjsfFieldContext ctx) {
  final name = ctx.path;
  final title = ctx.propSchema['title'] as String? ?? name;
  final ui = readUiFor(ctx.uiSchema, name);
  final decoration = inputDecorationFromUi(title, ui);
  final messages = messagesForField(ctx, name, ctx.propSchema);

  return ReactiveTextField<int>(
    formControlName: name,
    decoration: decoration,
    autofocus: ui.autofocus,
    keyboardType: TextInputType.number,
    validationMessages: messages,
    onChanged: (control) {
      if (control.value == null && ui.emptyValue != null) {
        control.value = ui.emptyValue as int?;
      }
    },
  );
}

ReactiveFormField _textArea(DjsfFieldContext ctx) {
  final name = ctx.path;
  final title = ctx.propSchema['title'] as String? ?? name;
  final ui = readUiFor(ctx.uiSchema, name);
  final decoration = inputDecorationFromUi(title, ui);
  final messages = messagesForField(ctx, name, ctx.propSchema);

  return ReactiveTextField<String>(
    formControlName: name,
    decoration: decoration,
    autofocus: ui.autofocus,
    minLines: 3,
    maxLines: 6,
    validationMessages: messages,
  );
}

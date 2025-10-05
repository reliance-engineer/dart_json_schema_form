import 'package:dart_json_schema_form/src/fields/defaults/number_field.dart';
import 'package:dart_json_schema_form/src/fields/defaults/text_field.dart';
import 'package:dart_json_schema_form/src/fields/defaults/textarea_field.dart';
import 'package:dart_json_schema_form/src/fields/registry.dart';
import 'package:reactive_forms/reactive_forms.dart';

DjsfFieldRegistry defaultFieldRegistry() => DjsfFieldRegistry({
      'string': (ctx) => DjsfTextField<String>(
            formControl: ctx.control as FormControl<String>,
            ctx: ctx,
          ),
      'text': (ctx) => DjsfTextField<String>(
            formControl: ctx.control as FormControl<String>,
            ctx: ctx,
          ),
      'integer': (ctx) => DjsfNumberField<int>(
            formControl: ctx.control as FormControl<int>,
            ctx: ctx,
          ),
      'number': (ctx) => DjsfNumberField<num>(
            formControl: ctx.control as FormControl<num>,
            ctx: ctx,
          ),
      'password': (ctx) => DjsfTextField<String>(
            formControl: ctx.control as FormControl<String>,
            ctx: ctx,
            obscureText: true,
          ),
      'textarea': (ctx) => DjsfTextAreaField(
            formControl: ctx.control as FormControl<String>,
            ctx: ctx,
          ),
      'tel': (ctx) => DjsfTextField<String>(
            formControl: ctx.control as FormControl<String>,
            ctx: ctx,
          ),
      'email': (ctx) => DjsfTextField<String>(
            formControl: ctx.control as FormControl<String>,
            ctx: ctx,
          ),
    });

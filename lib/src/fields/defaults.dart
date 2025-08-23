import 'package:dart_json_schema_form/src/fields/defaults/number_field.dart';
import 'package:dart_json_schema_form/src/fields/defaults/text_field.dart';
import 'package:dart_json_schema_form/src/fields/defaults/textarea_field.dart';
import 'package:dart_json_schema_form/src/fields/registry.dart';
import 'package:flutter/material.dart';

DjsfFieldRegistry defaultFieldRegistry() => DjsfFieldRegistry({
      'string': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
          ),
      'text': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
          ),
      'integer': (ctx) => DjsfNumberField<int>(
            formControlName: ctx.path,
            ctx: ctx,
            keyboardType: TextInputType.number,
          ),
      'number': (ctx) => DjsfNumberField<num>(
            formControlName: ctx.path,
            ctx: ctx,
          ),
      'password': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
            obscureText: true,
          ),
      'textarea': (ctx) => DjsfTextAreaField(
            formControlName: ctx.path,
            ctx: ctx,
          ),
      'tel': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
          ),
      'email': (ctx) => DjsfTextField<String>(
            formControlName: ctx.path,
            ctx: ctx,
          ),
    });

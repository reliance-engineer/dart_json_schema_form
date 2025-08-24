import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/i18n/bundles.dart';
import 'package:dart_json_schema_form/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  group('Ui utils', () {
    test('readUiFor parses uiSchema correctly', () {
      final schema = <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'email': {
            'type': 'string',
          },
        },
      };

      final uiSchema = {
        'email': {
          'ui:autofocus': true,
          'ui:emptyValue': '',
          'ui:placeholder': 'Enter email',
          'ui:autocomplete': 'email',
          'ui:description': 'We never share it',
          'ui:help': 'Use a valid email',
          'ui:options': {'inputType': 'email'},
        },
      };

      final form = FormGroup({
        'email': FormControl<String>(),
      });

      final ctx = DjsfFieldContext(
        type: 'email',
        form: form,
        schema: schema,
        uiSchema: uiSchema,
        path: 'email',
        propSchema: (schema['properties']! as JsonMap)['email'] as JsonMap,
        messages: IntlBundle(),
      );

      final ui = readUiFor(ctx);
      expect(ui.autofocus, isTrue);
      expect(ui.emptyValue, equals(''));
      expect(ui.hint, equals('Enter email'));
      expect(ui.autocomplete, equals('email'));
      expect(ui.description, equals('We never share it'));
      expect(ui.helper, equals('Use a valid email'));
      expect(ui.inputType, equals('email'));
      expect(ui.isPassword, isFalse);
      expect(ui.isTextarea, isFalse);

      // keyboardType inferred from inputType
      expect(ui.keyboardTypeForString(), equals(TextInputType.emailAddress));
    });

    test('password flags', () {
      final schema = <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'pwd': {
            'type': 'string',
          },
        },
      };

      final uiSchema = {
        'pwd': {
          'ui:options': {'inputType': 'password'},
        },
      };

      final form = FormGroup({
        'pwd': FormControl<String>(),
      });

      final ctx = DjsfFieldContext(
        type: 'password',
        form: form,
        schema: schema,
        uiSchema: uiSchema,
        path: 'pwd',
        propSchema: (schema['properties']! as JsonMap)['pwd'] as JsonMap,
        messages: IntlBundle(),
      );

      final ui = readUiFor(ctx);
      expect(ui.isPassword, isTrue);
      expect(ui.isTextarea, isFalse);
    });

    test('textarea flags', () {
      final schema = <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'bio': {
            'type': 'string',
          },
        },
      };

      final uiSchema = {
        'bio': {
          'ui:options': {'inputType': 'textarea'},
        },
      };

      final form = FormGroup({
        'bio': FormControl<String>(),
      });

      final ctx = DjsfFieldContext(
        type: 'textarea',
        form: form,
        schema: schema,
        uiSchema: uiSchema,
        path: 'bio',
        propSchema: (schema['properties']! as JsonMap)['bio'] as JsonMap,
        messages: IntlBundle(),
      );

      final ui = readUiFor(ctx);

      expect(ui.isTextarea, isTrue);
      expect(ui.isPassword, isFalse);
      expect(
        ui.keyboardTypeForString(),
        isNull,
      ); // default for textarea
    });

    test('inputDecorationFromUi applies hint/help', () {
      final schema = <String, dynamic>{
        'type': 'object',
        'properties': <String, dynamic>{
          'name': {
            'type': 'string',
          },
        },
      };

      final uiSchema = {
        'name': {
          'ui:placeholder': 'Full name',
          'ui:help': 'At least 2 words',
        },
      };

      final form = FormGroup({
        'name': FormControl<String>(),
      });

      final ctx = DjsfFieldContext(
        type: 'string',
        form: form,
        schema: schema,
        uiSchema: uiSchema,
        path: 'name',
        propSchema: (schema['properties']! as JsonMap)['name'] as JsonMap,
        messages: IntlBundle(),
      );

      final ui = readUiFor(ctx);

      final dec = inputDecorationFromUi('Name', ui);
      expect(dec.labelText, equals('Name'));
      expect(dec.hintText, equals('Full name'));
      expect(dec.helperText, equals('At least 2 words'));
    });
  });
}

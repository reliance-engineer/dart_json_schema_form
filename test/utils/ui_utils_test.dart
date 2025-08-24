import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_json_schema_form/src/utils/utils.dart';

void main() {
  group('Ui utils', () {
    test('readUiFor parses uiSchema correctly', () {
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

      final ui = readUiFor(uiSchema, 'email');
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

    test('password and textarea flags', () {
      final uiPassword = readUiFor(
        {
          'pwd': {
            'ui:options': {'inputType': 'password'},
          },
        },
        'pwd',
      );
      expect(uiPassword.isPassword, isTrue);
      expect(uiPassword.isTextarea, isFalse);

      final uiTextarea = readUiFor(
        {
          'bio': {
            'ui:options': {'inputType': 'textarea'},
          },
        },
        'bio',
      );
      expect(uiTextarea.isTextarea, isTrue);
      expect(uiTextarea.isPassword, isFalse);
      expect(
        uiTextarea.keyboardTypeForString(),
        isNull,
      ); // default for textarea
    });

    test('inputDecorationFromUi applies hint/help', () {
      final ui = readUiFor(
        {
          'name': {
            'ui:placeholder': 'Full name',
            'ui:help': 'At least 2 words',
          },
        },
        'name',
      );

      final dec = inputDecorationFromUi('Name', ui);
      expect(dec.labelText, equals('Name'));
      expect(dec.hintText, equals('Full name'));
      expect(dec.helperText, equals('At least 2 words'));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/src/parsers/schema_parser.dart';

void main() {
  group('SchemaParser validators', () {
    test('required validator marks empty control as invalid', () {
      final schema = {
        "type": "object",
        "required": ["firstName"],
        "properties": {
          "firstName": {"type": "string", "title": "First name"}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);

      final control = form.control('firstName') as FormControl<String>;
      expect(control.invalid, isTrue);
      expect(control.hasError(ValidationMessage.required), isTrue);

      control.value = 'Alice';
      expect(control.valid, isTrue);
    });

    test('minLength validator for string', () {
      final schema = {
        "type": "object",
        "properties": {
          "password": {"type": "string", "minLength": 3}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final control = form.control('password') as FormControl<String>;

      control.value = 'ab'; // too short
      expect(control.hasError(ValidationMessage.minLength), isTrue);

      control.value = 'abc'; // exactly min length
      expect(control.hasError(ValidationMessage.minLength), isFalse);
      expect(control.valid, isTrue);
    });

    test('maxLength validator for string', () {
      final schema = {
        "type": "object",
        "properties": {
          "code": {"type": "string", "maxLength": 5}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final control = form.control('code') as FormControl<String>;

      control.value = 'abcdef'; // too long
      expect(control.hasError(ValidationMessage.maxLength), isTrue);

      control.value = 'abcde'; // exactly max length
      expect(control.hasError(ValidationMessage.maxLength), isFalse);
      expect(control.valid, isTrue);
    });

    test('combines required + minLength + maxLength', () {
      final schema = {
        "type": "object",
        "required": ["username"],
        "properties": {
          "username": {
            "type": "string",
            "minLength": 3,
            "maxLength": 8,
          }
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final c = form.control('username') as FormControl<String>;

      // initially null → required error
      expect(c.hasError(ValidationMessage.required), isTrue);

      // too short
      c.value = 'ab';
      expect(c.hasError(ValidationMessage.minLength), isTrue);

      // too long
      c.value = 'abcdefghij';
      expect(c.hasError(ValidationMessage.maxLength), isTrue);

      // valid
      c.value = 'charlie';
      expect(c.valid, isTrue);
    });
    test('const validator: value must equal constant', () {
      final schema = {
        "type": "object",
        "properties": {
          "code": {"type": "string", "const": "XYZ"}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final c = form.control('code') as FormControl<String>;

      c.value = 'ABC';
      expect(c.hasError(ValidationMessage.equals), isTrue);

      c.value = 'XYZ';
      expect(c.valid, isTrue);
    });

    test('pattern validator: must match regex', () {
      final schema = {
        "type": "object",
        "properties": {
          "email": {"type": "string", "pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$"}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final c = form.control('email') as FormControl<String>;

      c.value = 'not-an-email';
      expect(c.hasError(ValidationMessage.pattern), isTrue);

      c.value = 'user@example.com';
      expect(c.valid, isTrue);
    });

    test('minimum/maximum on integer', () {
      final schema = {
        "type": "object",
        "properties": {
          "age": {"type": "integer", "minimum": 18, "maximum": 65}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final c = form.control('age') as FormControl<int>;

      c.value = 16;
      expect(c.hasError(ValidationMessage.min), isTrue);

      c.value = 70;
      expect(c.hasError(ValidationMessage.max), isTrue);

      c.value = 35;
      expect(c.valid, isTrue);
    });

    test('minimum/maximum on number (double)', () {
      final schema = {
        "type": "object",
        "properties": {
          "rating": {"type": "number", "minimum": 1.5, "maximum": 4.5}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final c = form.control('rating') as FormControl<double>;

      c.value = 1.0;
      expect(c.hasError(ValidationMessage.min), isTrue);

      c.value = 5.0;
      expect(c.hasError(ValidationMessage.max), isTrue);

      c.value = 3.3;
      expect(c.valid, isTrue);
    });

    test('boolean required: present vs true (depends on chosen behavior)', () {
      final schema = {
        "type": "object",
        "required": ["terms"],
        "properties": {
          "terms": {"type": "boolean"}
        }
      };

      final form = SchemaParser.buildFormGroup(schema);
      final c = form.control('terms') as FormControl<bool>;

      // If using requiredTrue:
      // initially null → requiredTrue error
      // c.value = false; // still invalid
      // expect(c.hasError(ValidationMessage.requiredTrue), isTrue);
      // c.value = true;
      // expect(c.valid, isTrue);

      // If using required (present):
      // initially null → required error
      expect(c.hasError(ValidationMessage.required), isTrue);
      c.value = false; // present but false
      expect(c.hasError(ValidationMessage.required), isFalse);
    });
  });
}

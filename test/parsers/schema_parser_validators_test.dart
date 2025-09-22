import 'package:dart_json_schema_form/src/parsers/schema_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  group('SchemaParser validators', () {
    test('required validator marks empty control as invalid', () {
      final schema = {
        "type": "object",
        "required": ["firstName"],
        "properties": {
          "firstName": {"type": "string", "title": "First name"},
        },
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
          "password": {"type": "string", "minLength": 3},
        },
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
          "code": {"type": "string", "maxLength": 5},
        },
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
          },
        },
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
          "code": {"type": "string", "const": "XYZ"},
        },
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
          "email": {"type": "string", "pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$"},
        },
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
          "age": {"type": "integer", "minimum": 18, "maximum": 65},
        },
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
          "rating": {"type": "number", "minimum": 1.5, "maximum": 4.5},
        },
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
          "terms": {"type": "boolean"},
        },
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

    group('SchemaParser array validators', () {
      test('minItems validator for array', () {
        final schema = {
          "type": "object",
          "properties": {
            "tags": {
              "type": "array",
              "items": {"type": "string"},
              "minItems": 2,
            },
          },
        };

        // Test with initial data
        var form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "tags": ["one"],
          },
        );
        var control = form.control('tags') as FormArray;
        expect(
          control.hasError('minItems'),
          isTrue,
          reason: "Should fail if items < minItems with initialData",
        );

        form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "tags": ["one", "two"],
          },
        );
        control = form.control('tags') as FormArray;
        expect(
          control.valid,
          isTrue,
          reason: "Should be valid if items == minItems with initialData",
        );

        // Test by manipulating the FormArray
        form = SchemaParser.buildFormGroup(schema);
        control = form.control('tags') as FormArray;

        control.add(FormControl<String>(value: 'apple'));
        // At this point, the FormArray itself might not automatically re-validate based on item changes
        // for minItems/maxItems. ReactiveForms usually validates on value changes or status changes.
        // Explicitly marking as touched or manually calling updateValueAndValidity might be needed
        // depending on how validation is triggered in the actual application.
        // For testing schema parsing to AbstractControl, we check the validator directly.
        expect(
          control.validators.isNotEmpty,
          isTrue,
          reason: "Control should have a validator.",
        );
        final errors = control.errors;
        expect(
          errors['minItems'],
          isNotNull,
          reason:
              "Should have minItems error when programmatically underpopulated",
        );

        control.add(FormControl<String>(value: 'banana'));
        final noErrors = control.errors;
        expect(
          noErrors['minItems'],
          isNull,
          reason:
              "Should not have minItems error when programmatically populated to minItems",
        );
        // After items are added to meet minItems, the control should become valid.
        // Depending on ReactiveForms' internal behavior, a manual re-validation might be implicitly triggered or you might need to call it.
        // For this test, assuming re-validation happens or .valid reflects the latest state after validator check:
        control.updateValueAndValidity(); // Ensure re-validation
        expect(
          control.valid,
          isTrue,
          reason:
              "Control should be valid after meeting minItems and revalidating",
        );
      });

      test('maxItems validator for array', () {
        final schema = {
          "type": "object",
          "properties": {
            "categories": {
              "type": "array",
              "items": {"type": "integer"},
              "maxItems": 3,
            },
          },
        };

        // Test with initial data
        var form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "categories": [1, 2, 3, 4],
          },
        );
        var control = form.control('categories') as FormArray;
        expect(
          control.hasError("maxItems"),
          isTrue,
          reason: "Should fail if items > maxItems with initialData",
        );

        form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "categories": [1, 2, 3],
          },
        );
        control = form.control('categories') as FormArray;
        expect(
          control.valid,
          isTrue,
          reason: "Should be valid if items == maxItems with initialData",
        );

        // Test by manipulating the FormArray
        form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "categories": [10, 20],
          },
        ); // Start with a valid number of items
        control = form.control('categories') as FormArray;
        expect(
          control.valid,
          isTrue,
          reason: "Control should initially be valid",
        );

        control.add(FormControl<int>(value: 30)); // Now 3 items, at maxItems
        // control.updateValueAndValidity(); // Ensure re-validation
        final noErrors = control.errors;
        expect(
          noErrors["maxItems"],
          isNull,
          reason: "Should not have maxItems error when at maxItems",
        );
        control.updateValueAndValidity();
        expect(
          control.valid,
          isTrue,
          reason: "Control should be valid at maxItems",
        );

        control.add(
          FormControl<int>(value: 40),
        ); // Now 4 items, exceeding maxItems
        final errors = control.errors;
        expect(
          errors["maxItems"],
          isNotNull,
          reason:
              "Should have maxItems error when programmatically overpopulated",
        );
        control.updateValueAndValidity();
        expect(
          control.invalid,
          isTrue,
          reason:
              "Control should be invalid after exceeding maxItems and revalidating",
        );
      });

      test('uniqueItems validator for array', () {
        final schema = {
          "type": "object",
          "properties": {
            "keywords": {
              "type": "array",
              "items": {"type": "string"},
              "uniqueItems": true,
            },
          },
        };

        // Test with initial data
        var form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "keywords": ["a", "b", "a"],
          },
        );
        var control = form.control('keywords') as FormArray;
        expect(
          control.hasError("uniqueItems"),
          isTrue,
          reason: "Should fail with duplicate items in initialData",
        );

        form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "keywords": ["a", "b", "c"],
          },
        );
        control = form.control('keywords') as FormArray;
        expect(
          control.valid,
          isTrue,
          reason: "Should be valid with unique items in initialData",
        );

        // Test by manipulating the FormArray
        form = SchemaParser.buildFormGroup(
          schema,
          formData: {
            "keywords": ["hello", "world"],
          },
        );
        control = form.control('keywords') as FormArray;
        expect(
          control.valid,
          isTrue,
          reason: "Control should initially be valid",
        );

        control.add(FormControl<String>(value: 'hello')); // Add a duplicate
        final errors = control.errors;
        expect(
          errors["uniqueItems"],
          isNotNull,
          reason: "Should have uniqueItems error after adding a duplicate",
        );
        control.updateValueAndValidity();
        expect(
          control.invalid,
          isTrue,
          reason:
              "Control should be invalid after adding duplicate and revalidating",
        );

        // Remove the duplicate and test again
        control
            .removeAt(control.controls.length - 1); // remove the last 'hello'
        control
            .add(FormControl<String>(value: 'test')); // add a new unique item
        final noErrors = control.errors;
        expect(
          noErrors["uniqueItems"],
          isNull,
          reason:
              "Should not have uniqueItems error after removing duplicate and adding unique",
        );
        control.updateValueAndValidity();
        expect(
          control.valid,
          isTrue,
          reason:
              "Control should be valid after fixing duplicates and revalidating",
        );
      });
    });
  });
}

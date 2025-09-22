import 'package:dart_json_schema_form/src/parsers/schema_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  test('SchemaParser creates a FormGroup with all properties as FormControls',
      () {
    final schema = {
      "type": "object",
      "properties": {
        "firstName": {"type": "string"},
        "age": {"type": "integer"},
        "bio": {"type": "string"},
      },
    };

    final form = SchemaParser.buildFormGroup(schema);

    expect(form.contains('firstName'), true);
    expect(form.contains('age'), true);
    expect(form.contains('bio'), true);

    expect(form.control('firstName').value, isNull);
    expect(form.control('age').value, isNull);
    expect(form.control('bio').value, isNull);
  });
  test('returns empty FormGroup if properties is empty', () {
    final schema = {"title": "A registration form", "properties": {}};
    final form = SchemaParser.buildFormGroup(schema);
    expect(form.controls.isEmpty, true);
  });

  test('returns empty FormGroup if properties is missing', () {
    final schema = {"title": "A registration form"};
    final form = SchemaParser.buildFormGroup(schema);
    expect(form.controls.isEmpty, true);
  });

  test('creates typed controls based on schema types', () {
    final schema = {
      "type": "object",
      "properties": {
        "firstName": {"type": "string"},
        "age": {"type": "integer"},
        "score": {"type": "number"},
        "isActive": {"type": "boolean"},
        "prefs": {"type": "object"},
        "items": {"type": "array"},
        "unspecified": {},
      },
    };

    final form = SchemaParser.buildFormGroup(schema);

    // Verify each property is correctly typed
    expect(form.control('firstName'), isA<FormControl<String>>());
    expect(form.control('age'), isA<FormControl<int>>());
    expect(form.control('score'), isA<FormControl<double>>());
    expect(form.control('isActive'), isA<FormControl<bool>>());
    expect(form.control('prefs'), isA<FormGroup>());
    expect(form.control('items'), isA<FormArray>());
    // Default fallback → string
    expect(form.control('unspecified'), isA<FormControl<String>>());
  });

  group('SchemaParser default values', () {
    test('uses default value from schema if no initialData is provided', () {
      final schema = {
        "type": "object",
        "properties": {
          "firstName": {"type": "string", "default": "Chuck"},
          "age": {"type": "integer", "default": 42},
          "active": {"type": "boolean", "default": true},
        },
      };

      final form = SchemaParser.buildFormGroup(schema);

      expect(form.control('firstName').value, 'Chuck');
      expect(form.control('age').value, 42);
      expect(form.control('active').value, true);
    });

    test('uses initialData instead of schema default', () {
      final schema = {
        "type": "object",
        "properties": {
          "firstName": {"type": "string", "default": "Chuck"},
        },
      };

      final form = SchemaParser.buildFormGroup(
        schema,
        formData: {"firstName": "Bruce"},
      );

      expect(form.control('firstName').value, 'Bruce');
    });

    test('falls back to null if neither default nor initialData', () {
      final schema = {
        "type": "object",
        "properties": {
          "nickname": {"type": "string"},
        },
      };

      final form = SchemaParser.buildFormGroup(schema);

      expect(form.control('nickname').value, isNull);
    });
  });

  group('SchemaParser nested objects', () {
    test('parses nested objects correctly', () {
      final schema = {
        "type": "object",
        "properties": {
          "level1": {
            "type": "object",
            "properties": {
              "level2text": {"type": "string"},
              "level2obj": {
                "type": "object",
                "properties": {
                  "level3bool": {"type": "boolean"},
                },
              },
            },
          },
        },
      };

      final formData = {
        "level1": {
          "level2text": "hello",
          "level2obj": {
            "level3bool": true,
          },
        },
      };

      final form = SchemaParser.buildFormGroup(schema, formData: formData);

      expect(form.control('level1'), isA<FormGroup>());
      final level1Group = form.control('level1') as FormGroup;

      expect(level1Group.control('level2text'), isA<FormControl<String>>());
      expect(level1Group.control('level2text').value, "hello");

      expect(level1Group.control('level2obj'), isA<FormGroup>());
      final level2ObjGroup = level1Group.control('level2obj') as FormGroup;

      expect(level2ObjGroup.control('level3bool'), isA<FormControl<bool>>());
      expect(level2ObjGroup.control('level3bool').value, true);
    });

    test('creates nested FormGroup with internal required and defaults', () {
      final schema = {
        "type": "object",
        "properties": {
          "profile": {
            "type": "object",
            "required": ["city"],
            "properties": {
              "firstName": {"type": "string", "default": "Alice"},
              "city": {"type": "string"},
              "age": {"type": "integer", "default": 30},
            },
          },
        },
      };

      final form = SchemaParser.buildFormGroup(schema);
      final profile = form.control('profile');

      expect(profile, isA<FormGroup>());
      final fg = profile as FormGroup;

      // internal required: 'city' should start invalid
      final city = fg.control('city') as FormControl<String>;
      expect(city.invalid, isTrue);
      expect(city.hasError(ValidationMessage.required), isTrue);

      // defaults
      expect((fg.control('firstName') as FormControl<String>).value, 'Alice');
      expect((fg.control('age') as FormControl<int>).value, 30);

      // fix city
      city.value = 'London';
      expect(fg.valid, isTrue);
    });

    test('initial formData overrides defaults within nested object', () {
      final schema = {
        "type": "object",
        "properties": {
          "profile": {
            "type": "object",
            "properties": {
              "firstName": {"type": "string", "default": "Alice"},
              "age": {"type": "integer", "default": 30},
            },
          },
        },
      };

      final form = SchemaParser.buildFormGroup(
        schema,
        formData: {
          "profile": {"firstName": "Bob"},
        },
      );

      final fg = form.control('profile') as FormGroup;
      expect((fg.control('firstName') as FormControl<String>).value, 'Bob');
      expect(
        (fg.control('age') as FormControl<int>).value,
        30,
      ); // untouched default
    });
  });

  group('SchemaParser array parsing', () {
    test('parses array of simple types with initialData', () {
      final schema = {
        "type": "object",
        "properties": {
          "tags": {
            "type": "array",
            "items": {"type": "string"},
          },
        },
      };
      final formData = {
        "tags": ["dart", "flutter"],
      };
      final form = SchemaParser.buildFormGroup(schema, formData: formData);
      expect(form.control('tags'), isA<FormArray>());
      final tagsArray = form.control('tags') as FormArray;
      expect(tagsArray.controls.length, 2);
      expect(tagsArray.control('0').value, "dart");
      expect(tagsArray.control('1').value, "flutter");
    });

    test('parses array of objects with initialData', () {
      final schema = {
        "type": "object",
        "properties": {
          "users": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "name": {"type": "string"},
                "age": {"type": "integer"},
              },
            },
          },
        },
      };
      final formData = {
        "users": [
          {"name": "Alice", "age": 30},
          {"name": "Bob", "age": 25},
        ],
      };
      final form = SchemaParser.buildFormGroup(schema, formData: formData);
      expect(form.control('users'), isA<FormArray>());
      final usersArray = form.control('users') as FormArray;
      expect(usersArray.controls.length, 2);
      expect(usersArray.control('0'), isA<FormGroup>());
      expect(
        (usersArray.control('0') as FormGroup).control('name').value,
        "Alice",
      );
      expect((usersArray.control('0') as FormGroup).control('age').value, 30);
      expect(
        (usersArray.control('1') as FormGroup).control('name').value,
        "Bob",
      );
      expect((usersArray.control('1') as FormGroup).control('age').value, 25);
    });

    test('parses array with default values from schema', () {
      final schema = {
        "type": "object",
        "properties": {
          "colors": {
            "type": "array",
            "items": {"type": "string"},
            "default": ["red", "green"],
          },
        },
      };
      final form = SchemaParser.buildFormGroup(schema);
      expect(form.control('colors'), isA<FormArray>());
      final colorsArray = form.control('colors') as FormArray;
      expect(colorsArray.controls.length, 2);
      expect(colorsArray.control('0').value, "red");
      expect(colorsArray.control('1').value, "green");
    });

    test('parses empty array when no initialData or default', () {
      final schema = {
        "type": "object",
        "properties": {
          "tasks": {
            "type": "array",
            "items": {"type": "string"},
          },
        },
      };
      final form = SchemaParser.buildFormGroup(schema);
      expect(form.control('tasks'), isA<FormArray>());
      final tasksArray = form.control('tasks') as FormArray;
      expect(tasksArray.controls.isEmpty, true);
    });
  });

  group('SchemaParser array of objects', () {
    test('creates FormArray of FormGroup items with required inside items', () {
      final schema = {
        "type": "object",
        "properties": {
          "addresses": {
            "type": "array",
            "items": {
              "type": "object",
              "required": ["city"],
              "properties": {
                "street": {"type": "string"},
                "city": {"type": "string"},
                "zip": {"type": "string"},
              },
            },
          },
        },
      };

      final form = SchemaParser.buildFormGroup(
        schema,
        formData: {
          "addresses": [
            {"street": "Main 1", "zip": "12345"}, // missing city
            {"street": "Main 2", "city": "Berlin", "zip": "10115"},
          ],
        },
      );

      final arr = form.control('addresses') as FormArray;
      expect(arr.controls, hasLength(2));
      expect(arr.controls.first, isA<FormGroup>());
      expect(arr.controls.last, isA<FormGroup>());

      final first = arr.controls.first as FormGroup;
      final last = arr.controls.last as FormGroup;

      // first is invalid due to required city
      final firstCity = first.control('city') as FormControl<String>;
      expect(firstCity.invalid, isTrue);
      expect(firstCity.hasError(ValidationMessage.required), isTrue);

      // second should be valid (city present)
      expect((last.control('city') as FormControl<String>).value, 'Berlin');
    });

    test(
        'defaults inside item schema are applied if not overridden by formData',
        () {
      final schema = {
        "type": "object",
        "properties": {
          "addresses": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "country": {"type": "string", "default": "DE"},
                "city": {"type": "string"},
              },
            },
          },
        },
      };

      final form = SchemaParser.buildFormGroup(
        schema,
        formData: {
          "addresses": [
            {"city": "Hamburg"},
            {"country": "FR", "city": "Paris"},
          ],
        },
      );

      final arr = form.control('addresses') as FormArray;
      final first = arr.controls.first as FormGroup;
      final second = arr.controls.last as FormGroup;

      expect(
        (first.control('country') as FormControl<String>).value,
        'DE',
      ); // default applied
      expect(
        (second.control('country') as FormControl<String>).value,
        'FR',
      ); // overridden
    });
  });

  group('SchemaParser initial value precedence', () {
    test('formData > default (primitive, object, array)', () {
      final schema = {
        "type": "object",
        "properties": {
          "name": {"type": "string", "default": "Alice"},
          "profile": {
            "type": "object",
            "properties": {
              "age": {"type": "integer", "default": 30},
              "city": {"type": "string", "default": "London"},
            },
          },
          "tags": {
            "type": "array",
            "items": {"type": "string"},
          },
        },
      };

      final form = SchemaParser.buildFormGroup(
        schema,
        formData: {
          "name": "Bob", // overrides default
          "profile": {"city": "Berlin"}, // overrides just city
          "tags": ["x", "y"],
        },
      );

      expect((form.control('name') as FormControl<String>).value, 'Bob');

      final profile = form.control('profile') as FormGroup;
      expect(
        (profile.control('age') as FormControl<int>).value,
        30,
      ); // default remains
      expect(
        (profile.control('city') as FormControl<String>).value,
        'Berlin',
      ); // overridden

      final tags = form.control('tags') as FormArray;
      expect(tags.controls.length, 2);
      expect((tags.controls[1] as FormControl<String>).value, 'y');
    });
  });
}

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
      }
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
}

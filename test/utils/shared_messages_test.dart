import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dart_json_schema_form/src/utils/shared_messages.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

// Fake bundle to make messages deterministic
class _FakeBundle implements DjsfMessageBundle {
  @override
  String equals(allowed) => 'EQ $allowed';
  @override
  String max(num limit) => 'MAX $limit';
  @override
  String min(num limit) => 'MIN $limit';
  @override
  String maxLength(int limit) => 'MAXLEN $limit';
  @override
  String minLength(int limit) => 'MINLEN $limit';
  @override
  String pattern() => 'PATTERN';
  @override
  String required() => 'REQUIRED';
}

void main() {
  group('messagesForField', () {
    DjsfFieldContext ctx0({TransformErrors? transform}) {
      final form = FormGroup({
        'f': FormControl<String>(
          validators: [Validators.required, Validators.minLength(3)],
        ),
      });
      final schema = {
        'properties': {
          'f': {'type': 'string', 'title': 'F', 'minLength': 3},
        },
      };
      return DjsfFieldContext(
        type: 'string',
        form: form,
        schema: schema,
        uiSchema: const {},
        path: 'f',
        propSchema: schema['properties']?['f'] as Map<String, dynamic>,
        messages: _FakeBundle(),
        transformErrors: transform,
      );
    }

    test('returns default bundle messages', () {
      final ctx = ctx0();
      final map = messagesForField(ctx, 'f', ctx.propSchema);

      expect(map.containsKey(ValidationMessage.required), isTrue);
      expect(map.containsKey(ValidationMessage.minLength), isTrue);

      // Call functions to get strings
      final reqMsg = map[ValidationMessage.required]!.call({});
      final minLenMsg = map[ValidationMessage.minLength]!.call({});

      expect(reqMsg, equals('REQUIRED'));
      expect(minLenMsg, equals('MINLEN 3'));
    });

    test('transformErrors overrides messages', () {
      final ctx = ctx0(
        transform: (errors) {
          return errors.map((e) {
            if (e.name == 'required' && e.property == '.f') {
              e.message = 'CUSTOM REQUIRED';
            }
            if (e.name == 'minLength') {
              e.message = 'CUSTOM MINLEN';
            }
            return e;
          }).toList();
        },
      );

      final map = messagesForField(ctx, 'f', ctx.propSchema);
      expect(
        map[ValidationMessage.required]!.call({}),
        equals('CUSTOM REQUIRED'),
      );
      expect(
        map[ValidationMessage.minLength]!.call({}),
        equals('CUSTOM MINLEN'),
      );
    });
  });
}

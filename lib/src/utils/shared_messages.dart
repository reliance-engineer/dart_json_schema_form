import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/src/types/djsf_error.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Builds the validationMessages map for a field using the current i18n bundle
/// and the optional RJSF-like transformErrors hook.
///
/// NOTE: reactive_forms (v17+) expects:
///   [Map<String, ValidationMessageFunction>]
/// where ValidationMessageFunction = String Function(Object error)
Map<String, ValidationMessageFunction> messagesForField(
  DjsfFieldContext ctx,
  String fieldName,
  JsonMap propSchema,
) {
  return {
    ValidationMessage.required: (error) => _transformSingleError(
          ctx,
          fieldName,
          'required',
          ctx.messages.required(),
          propSchema,
        ),
    ValidationMessage.minLength: (error) {
      final limit = _asInt(propSchema['minLength']) ?? 0;
      return _transformSingleError(
        ctx,
        fieldName,
        'minLength',
        ctx.messages.minLength(limit),
        propSchema,
        params: {'limit': limit},
      );
    },
    ValidationMessage.maxLength: (error) {
      final limit = _asInt(propSchema['maxLength']) ?? 0;
      return _transformSingleError(
        ctx,
        fieldName,
        'maxLength',
        ctx.messages.maxLength(limit),
        propSchema,
        params: {'limit': limit},
      );
    },
    ValidationMessage.pattern: (error) => _transformSingleError(
          ctx,
          fieldName,
          'pattern',
          ctx.messages.pattern(),
          propSchema,
          params: {'pattern': propSchema['pattern']},
        ),
    ValidationMessage.min: (error) {
      final limit = _asNum(propSchema['minimum']) ?? 0;
      return _transformSingleError(
        ctx,
        fieldName,
        'min',
        ctx.messages.min(limit),
        propSchema,
        params: {'limit': limit},
      );
    },
    ValidationMessage.max: (error) {
      final limit = _asNum(propSchema['maximum']) ?? 0;
      return _transformSingleError(
        ctx,
        fieldName,
        'max',
        ctx.messages.max(limit),
        propSchema,
        params: {'limit': limit},
      );
    },
    ValidationMessage.equals: (error) {
      final allowed = propSchema['const'];
      return _transformSingleError(
        ctx,
        fieldName,
        'equals',
        ctx.messages.equals(allowed),
        propSchema,
        params: {'allowed': allowed},
      );
    },
  };
}

/// Applies the RJSF-like transformErrors (if provided) to a single error item
/// and returns the final message to show.
String _transformSingleError(
  DjsfFieldContext ctx,
  String fieldName,
  String name,
  String defaultMessage,
  JsonMap propSchema, {
  Map<String, Object?>? params,
}) {
  final error = DjsfError(
    name: name,
    property: '.$fieldName',
    message: defaultMessage,
    params: params,
  );

  if (ctx.transformErrors != null) {
    final out = ctx.transformErrors!([error]);
    if (out.isNotEmpty) {
      return out.first.message;
    }
  }
  return defaultMessage;
}

int? _asInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

num? _asNum(dynamic v) {
  if (v is num) return v;
  if (v is String) return num.tryParse(v);
  return null;
}

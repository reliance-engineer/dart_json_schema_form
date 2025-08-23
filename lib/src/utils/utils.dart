import 'package:dart_json_schema_form/src/types/types.dart';
import 'package:flutter/material.dart';

/// Parsed view of the uiSchema for a single field.
class UiFieldConfig {
  UiFieldConfig({
    this.autofocus = false,
    this.emptyValue,
    this.placeholder,
    this.autocomplete,
    this.description,
    this.inputType,
  });

  /// ui:autofocus
  final bool autofocus;

  /// ui:emptyValue
  final dynamic emptyValue;

  /// ui:placeholder
  final String? placeholder;

  /// ui:autocomplete (mapped to autofillHints)
  final String? autocomplete;

  /// ui:description (mapped to helperText)
  final String? description;

  /// ui:options.inputType (email|tel|url|number|password|textarea|...)
  final String? inputType;

  /// Heuristic: best keyboard type for string inputs based on inputType.
  TextInputType? keyboardTypeForString() {
    switch (inputType) {
      case 'email':
        return TextInputType.emailAddress;
      case 'tel':
      case 'phone':
        return TextInputType.phone;
      case 'url':
        return TextInputType.url;
      case 'number':
        return TextInputType.number;
      default:
        return null;
    }
  }

  /// Convenience flags.
  bool get isPassword => inputType == 'password';
  bool get isTextarea => inputType == 'textarea';
}

/// Reads uiSchema[name] and returns a normalized UiFieldConfig.
/// Expects the whole uiSchema object and the field name.
UiFieldConfig readUiFor(JsonMap? uiSchema, String fieldName) {
  final raw = (uiSchema?[fieldName] is Map)
      ? Map<String, dynamic>.from(uiSchema![fieldName] as Map)
      : const <String, dynamic>{};

  final options = (raw['ui:options'] is Map)
      ? Map<String, dynamic>.from(raw['ui:options'] as Map)
      : const <String, dynamic>{};

  return UiFieldConfig(
    autofocus: raw['ui:autofocus'] == true,
    emptyValue: raw.containsKey('ui:emptyValue') ? raw['ui:emptyValue'] : null,
    placeholder: raw['ui:placeholder'] as String?,
    autocomplete: raw['ui:autocomplete'] as String?,
    description: raw['ui:description'] as String?,
    inputType: options['inputType'] as String?,
  );
}

/// Builds an InputDecoration from label and UiFieldConfig.
InputDecoration inputDecorationFromUi(String label, UiFieldConfig ui) {
  return InputDecoration(
    labelText: label,
    hintText: ui.placeholder,
    helperText: ui.description,
  );
}

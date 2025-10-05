# dart\\_json\\_schema\\_form

[![codecov](https://codecov.io/gh/reliance-engineer/dart_json_schema_form/graph/badge.svg?token=1MT24L1VK3)](https://codecov.io/gh/reliance-engineer/dart_json_schema_form)
[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter_%3E%3D_3.24.2-blue?logo=flutter)](https://flutter.dev)
[![Made with Dart](https://img.shields.io/badge/Made%20with-Dart_%3E%3D_3.5.2-blue?logo=dart)](https://dart.dev)

---

## 📖 Overview

`dart_json_schema_form` (DJSF) is a **Flutter/Dart** package inspired by [RJSF (React JSON Schema Form)](https://rjsf-team.github.io/react-jsonschema-form/).
It allows you to render dynamic forms in Flutter from a **JSON Schema** + **uiSchema**, using [`reactive_forms`](https://pub.dev/packages/reactive_forms) under the hood.

* Input: JSON schema (RJSF compatible)
* Output: a Flutter widget that renders a form automatically

### Features

  * Schema-based field rendering
  * Built-in validators from JSON Schema keywords
  * RJSF-style `transformErrors` for custom error messages
  * Built-in localized validation messages (`en`, `es`, `de`, `it`, `pt`, `fr`, `nl`, `ja`, `zh`, `ru`, `pl`)
  * `uiSchema` props (`ui:placeholder`, `ui:description`, `ui:options.inputType`, etc.)
  * Custom field registry for extensibility
  * Arrays with `minItems`, `maxItems`, `uniqueItems`
  * Nested objects rendered as sub-forms
  * Localized UI labels for arrays (`arrayAddItem`, `arrayRemoveItem`, `arrayItemTitle`)
  * Container registry to override array rendering


---

## 📑 Table of Contents

- [Overview](#-overview)
- [Basic Usage](#-basic-usage)
- [Validation Example](#-validation-example)
- [Custom Validation Messages (transformErrors)](#-custom-validation-messages-transformerrors)
- [Built-in Validation Messages (i18n)](#-built-in-validation-messages-i18n))
- [uiSchema Example](#-uischema-example)
- [Custom Fields](#%EF%B8%8F-custom-fields)
- [Arrays and Objects](#-arrays-and-objects)
   * [Arrays Example](#-arrays-example)
   * [Nested Objects Example](#%EF%B8%8F-nested-objects-example)
   * [Localized UI Labels](#-localized-ui-labels)
   * [Container Registry (advanced)](#-container-registry-advanced)
- [Docs & Contributing](#-docs--contributing)


---

## ⚙️ Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dart_json_schema_form: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';

final schema = {
  "title": "Registration",
  "type": "object",
  "properties": {
    "firstName": {"type": "string", "title": "First Name"},
    "lastName": {"type": "string", "title": "Last Name"},
    "age": {"type": "integer", "title": "Age"}
  },
  "required": ["firstName", "lastName"]
};

class MyFormPage extends StatelessWidget {
  const MyFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration Form")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DjsfForm(schema: schema),
      ),
    );
  }
}
```

---

## ✅ Validation Example

DJSF automatically applies validators from JSON Schema keywords like `required`, `minLength`, `maxLength`, `pattern`, `minimum`, `maximum`, and `const`.

```dart
final schema = {
  "title": "Sign up",
  "required": ["email"],
  "properties": {
    "firstName": {"type": "string", "title": "Full Name", "minLength": 5},
    "email": {"type": "string", "title": "Email", "pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$"},
    "age": {"type": "integer", "title": "Age", "minimum": 18}
  }
};

DjsfForm(schema: schema);
```

Errors will show when fields are touched or after pressing **Submit**.

---

## ✨ Custom Validation Messages (transformErrors)

Like RJSF, you can customize messages programmatically with `transformErrors`.

```dart
DjsfForm(
  schema: schema,
  transformErrors: (errors) {
    return errors.map((e) {
      if (e.name == 'pattern' && e.property == '.email') {
        e.message = 'Please enter a valid email address';
      }
      if (e.name == 'min' && e.property == '.age') {
        final limit = e.params?['limit'];
        e.message = 'You must be at least $limit years old';
      }
      return e;
    }).toList();
  },
);
```

---

## 🌍 Built-in Validation Messages (i18n)

DJSF includes built-in message bundles for multiple languages:

* `en`, `es`, `de`, `it`, `pt`, `fr`, `nl`, `ja`, `zh`, `ru`, `pl`

### Option 1: Pass locale per form

```dart
DjsfForm(schema: schema, locale: 'es'); // "Este campo es obligatorio"
```

### Option 2: Set a global default

```dart
void main() {
  DjsfConfig.init(locale: 'de');
  runApp(const MyApp());
}
```

### Option 3: Use a custom Intl bundle

```dart
DjsfForm(
  schema: schema,
  messagesBundle: IntlBundle(), // backed by your .arb translations
);
```

**Precedence:**
`messagesBundle` > `locale` > global `DjsfConfig`

---

## 🎨 uiSchema Example

DJSF supports RJSF’s `uiSchema` for customizing field rendering:

```dart
final schema = {
  "title": "Registration",
  "properties": {
    "email": {"type": "string", "title": "Email"},
    "bio": {"type": "string", "title": "Bio"},
    "password": {"type": "string", "title": "Password"}
  },
  "required": ["email"]
};

final uiSchema = {
  "email": {
    "ui:autofocus": true,
    "ui:placeholder": "Enter your email",
    "ui:autocomplete": "email",
    "ui:description": "We never share your email",
    "ui:options": {"inputType": "email"}
  },
  "bio": {
    "ui:widget": "textarea",
    "ui:emptyValue": "N/A"
  },
  "password": {
    "ui:widget": "password",
    "ui:help": "Hint: Make it strong!"
  }
};

DjsfForm(schema: schema, uiSchema: uiSchema);
```

Supported `uiSchema` props so far:

* `ui:autofocus`
* `ui:emptyValue`
* `ui:placeholder`
* `ui:autocomplete`
* `ui:description`
* `ui:widget` (`password`, `textarea`, …)
* `ui:options.inputType` (`email`, `tel`, `url`, `number`, etc.)

---

## 🛠️ Custom Fields

You can extend DJSF with your own field widgets.

All custom fields must return a **`ReactiveFormField`**. Register them in a `DjsfFieldRegistry` and pass it to the form:

```dart
final registry = defaultFieldRegistry().merge(
  DjsfFieldRegistry({
    'uppercase': (ctx) {
      return ReactiveTextField<String>(
        formControlName: ctx.path,
        decoration: const InputDecoration(labelText: 'Uppercase'),
        onChanged: (c) {
          final v = c.value ?? '';
          if (v != v.toUpperCase()) {
            c.updateValue(v.toUpperCase(), emitEvent: false);
          }
        },
      );
    },
  }),
);

final uiSchema = {
  'nickname': {'ui:widget': 'uppercase'}
};

DjsfForm(
  schema: schema,
  uiSchema: uiSchema,
  fieldRegistry: registry,
);
```

Resolution order:

1. `ui:widget`
2. `ui:options.inputType`
3. JSON Schema `type`
4. fallback to `string`

---

✅ With these options, you can render dynamic forms with validators, customize or translate messages, and integrate seamlessly into your Flutter app.

## 📜 Arrays and Objects

### 📦 Arrays Example
--
#### Dynamic Array
This json will render a --"dynamic"-- array of fields. New fields can be added and/or removed from the form. Each item will have a field with the specified `item.type`.

```dart
final schema = {
  "title": "Tags",
  "type": "object",
  "properties": {
    "tags": {
      "type": "array",
      "title": "Tags",
      "items": {"type": "string", "title": "Tag"},
      "minItems": 1
    }
  }
};

final uiSchema = {
  "tags": {
    "ui:options": {
      "addButtonText": "Add tag",
      "removable": true
    }
  }
};

DjsfForm(schema: schema, uiSchema: uiSchema);
```

Supported array options:

* `minItems` : If defined the form will start with an empty blanc field. If not then just the `Add Item` button will be shown.
* `maxItems`, `uniqueItems` : Used for validation.
* `ui:options.addButtonText`: To modify the `Add Item` label.
* `ui:options.addable`, `removable`, `orderable`: If you want the list to be static, removable or orderable.

--

#### Static Array

This json will render a --"static"-- array of fields. Is not possible to add new fields to the array. Each item will have a field with the specified `item.type`.

```dart
final schema = {
  "title": "Tags",
  "type": "object",
  "properties": {
    "tags": {
      "type": "array",
      "title": "Tags",
      "items": [
         {"type": "string", "title": "Tag"}
       ],
    }
  }
};

final uiSchema = {
};

DjsfForm(schema: schema, uiSchema: uiSchema);
```

---

### 🏗️ Nested Objects Example

```dart
final schema = {
  "title": "User",
  "type": "object",
  "properties": {
    "addresses": {
      "type": "array",
      "title": "Addresses",
      "items": {
        "type": "object",
        "title": "Address",
        "required": ["city"],
        "properties": {
          "street": {"type": "string", "title": "Street"},
          "city": {"type": "string", "title": "City"},
          "zip": {"type": "string", "title": "ZIP", "pattern": r"^[0-9]{5}$"}
        }
      },
      "minItems": 1
    }
  }
};

final uiSchema = {
  "addresses": {
    "ui:options": {"addButtonText": "Add address"},
    "items": {
      "street": {"ui:placeholder": "Main St 123"},
      "zip": {"ui:placeholder": "12345"}
    }
  }
};

DjsfForm(schema: schema, uiSchema: uiSchema);
```

✅ This renders a list of nested forms where each item is a full address object.

---

### 🌐 Localized UI Labels

Array-related labels (`Add item`, `Remove`, `Item #n`) are localized through the same Intl ARB files as validation messages.

Default ARB keys:

```jsonc
"arrayAddItem": "Add item",
"arrayRemoveItem": "Remove",
"arrayItemTitle": "Item {index}"
```

Example in Spanish (`intl_es.arb`):

```jsonc
"arrayAddItem": "Añadir elemento",
"arrayRemoveItem": "Eliminar",
"arrayItemTitle": "Elemento {index}"
```

Usage (auto-resolves by locale):

```dart
DjsfForm(schema: schema, locale: \'es\');
```

---

### 🔌 Container Registry (advanced)

Developers can override how arrays are rendered via the container registry:

```dart
final myContainers = defaultContainerRegistry().copyWith(
  arrayBuilder: (ctx) => MyFancyArrayWidget(ctx: ctx),
);

DjsfForm(
  schema: schema,
  uiSchema: uiSchema,
  containerRegistry: myContainers,
);
```

## 📚 Docs & Contributing

* [Contributing Guidelines](CONTRIBUTING.md)
* [Code of Conduct](CODE_OF_CONDUCT.md)
* [License (Apache 2.0)](LICENSE.md)
* [Notice / Attribution](NOTICE)

---

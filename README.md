# dart\_json\_schema\_form

[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter_%3E%3D_3.24.2-blue?logo=flutter)](https://flutter.dev)
[![Made with Dart](https://img.shields.io/badge/Made%20with-Dart_%3E%3D_3.5.2-blue?logo=dart)](https://dart.dev)

---

## 📖 Overview

`dart_json_schema_form` (DJSF) is a **Flutter/Dart** package inspired by [RJSF (React JSON Schema Form)](https://rjsf-team.github.io/react-jsonschema-form/).
It allows you to render dynamic forms in Flutter from a **JSON Schema** + **uiSchema**, using [`reactive_forms`](https://pub.dev/packages/reactive_forms) under the hood.

* Input: JSON schema (RJSF compatible)
* Output: a Flutter widget that renders a form automatically
* Features:

  * Schema-based field rendering
  * Built-in validators from JSON Schema keywords
  * RJSF-style `transformErrors` for custom error messages
  * Built-in localized validation messages (`en`, `es`, `de`, `it`, `pt`, `fr`, `nl`, `ja`, `zh`, `ru`, `pl`)

---

## 📑 Table of Contents

1. [Installation](#installation)
2. [Basic Usage](#basic-usage)
3. [Validation Example](#validation-example)
4. [Custom Validation Messages (transformErrors)](#custom-validation-messages-transformerrors)
5. [Built-in Validation Messages (i18n)](#built-in-validation-messages-i18n)

---

## ⚙️ Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dart_json_schema_form: ^0.1.0 # use latest version
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

---

✅ With these options, you can render dynamic forms with validators, customize or translate messages, and integrate seamlessly into your Flutter app.

---

👉 Do you want me to also add a **screenshot/GIF** of the example form running, so readers instantly see what it looks like?

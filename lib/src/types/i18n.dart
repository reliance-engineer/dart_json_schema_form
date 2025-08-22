import 'dart:ui';

import 'package:dart_json_schema_form/src/types/types.dart';

import '../../generated/l10n.dart';
import '../i18n/bundles.dart';

/// Global configuration with defaults and a registry of built-in bundles.
class DjsfConfig {
  static String _defaultLocale = 'en';
  static DjsfMessageBundle? _defaultBundle;

  /// Optional global init; call once in your app entrypoint if you want.
  static Future<void> init({String? locale, DjsfMessageBundle? bundle}) {
    if (locale != null) _defaultLocale = locale;
    if (bundle != null) _defaultBundle = bundle;
    return resolve(locale: _defaultLocale, bundle: _defaultBundle);
  }

  /// Resolve a bundle using priority:
  /// 1) explicit bundle
  /// 2) explicit locale
  /// 3) global bundle set via init
  /// 4) builtin by global/default locale
  /// 5) builtin 'en'
  static Future<DjsfMessageBundle> resolve(
      {String? locale, DjsfMessageBundle? bundle}) async {
    if (bundle != null) return bundle;

    if (locale != null) {
      await S.load(Locale(locale));
      return IntlBundle();
    }

    if (_defaultBundle != null) return _defaultBundle!;

    await S.load(Locale(_defaultLocale));
    return IntlBundle();
  }
}

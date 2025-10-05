import 'package:dart_json_schema_form/generated/l10n.dart' as djsf_l10n;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BaseApp extends StatelessWidget {
  final Widget child;

  const BaseApp({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        djsf_l10n.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );
  }
}

import 'package:dart_json_schema_form/src/containers/context.dart';
import 'package:flutter/widgets.dart';

typedef DjsfArrayBuilder = Widget Function(DjsfArrayContext ctx);

class DjsfContainerRegistry {
  DjsfContainerRegistry({required this.arrayBuilder});

  final DjsfArrayBuilder arrayBuilder;

  DjsfContainerRegistry copyWith({DjsfArrayBuilder? arrayBuilder}) =>
      DjsfContainerRegistry(arrayBuilder: arrayBuilder ?? this.arrayBuilder);
}

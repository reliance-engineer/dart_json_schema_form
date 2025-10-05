import 'package:dart_json_schema_form/src/containers/containers.dart';
import 'package:dart_json_schema_form/src/containers/defaults/array_field.dart';

DjsfContainerRegistry defaultContainerRegistry() => DjsfContainerRegistry(
      arrayBuilder: (ctx) => DjsfArrayField(
        ctx: ctx,
        onDelete: (index) {
          ctx.control.removeAt(index);
        },
      ),
    );

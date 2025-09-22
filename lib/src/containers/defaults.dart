import 'package:dart_json_schema_form/src/containers/containers.dart';
import 'package:dart_json_schema_form/src/containers/defaults/array_field.dart';

DjsfContainerRegistry defaultContainerRegistry() => DjsfContainerRegistry(
      arrayBuilder: (ctx) => DjsfArrayField(
        arrayControl: ctx.control,
        arraySchema: ctx.arraySchema,
        arrayUiSchema: ctx.arrayUiSchema,
        messages: ctx.messages,
        transformErrors: ctx.transformErrors,
        registry: ctx.fieldRegistry,
        parentSchema: ctx.parentSchema,
        fieldName: ctx.fieldName,
      ),
    );

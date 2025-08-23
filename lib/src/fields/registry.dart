import 'package:dart_json_schema_form/src/types/types.dart';

class DjsfFieldRegistry {
  DjsfFieldRegistry(this.builders);

  final Map<String, DjsfFieldBuilder> builders;

  bool contains(String key) => builders.containsKey(key);
  DjsfFieldBuilder? operator [](String key) => builders[key];

  DjsfFieldRegistry merge(DjsfFieldRegistry other) =>
      DjsfFieldRegistry({...builders, ...other.builders});
}

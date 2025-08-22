import 'djsf_error.dart';

typedef JsonMap = Map<String, dynamic>;

typedef TransformErrors = List<DjsfError> Function(List<DjsfError> errors);

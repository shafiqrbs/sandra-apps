import 'package:flutter/foundation.dart';

Future<List<T>?> parseList<T>({
  required List<dynamic>? list,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  if (list == null) {
    return null;
  }

  try {
    if (kDebugMode) {
      print('\x1B[33m Parsing List $T \x1B[0m\n');
    }
    return await compute(
      _parseListInIsolate,
      _ParseListParams<T>(
        list,
        fromJson,
      ),
    );
  } catch (e,s) {
    if (kDebugMode) {
      print('\x1B[31m Error parsing list: $e \x1B[0m\n');
      print(s);
    }
  }
  return null;
}

class _ParseListParams<T> {
  final List<dynamic> list;
  final T Function(Map<String, dynamic>) fromJson;

  _ParseListParams(this.list, this.fromJson);
}

List<T> _parseListInIsolate<T>(_ParseListParams<T> params) {
  return params.list.map((e) => params.fromJson(e)).toList();
}

// parse single object
Future<T?> parseObject<T>({
  required Map<String, dynamic>? object,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  if (object == null) {
    return null;
  }

  try {
    if (kDebugMode) {
      print('\x1B[33m Parsing Object $T \x1B[0m\n');
    }
    return await compute(
      _parseObjectInIsolate,
      _ParseObjectParams<T>(
        object,
        fromJson,
      ),
    );
  } catch (e,s) {
    if (kDebugMode) {
      print('\x1B[31m Error parsing object: $e \x1B[0m\n');
      print(s);
    }
  }
  return null;
}

class _ParseObjectParams<T> {
  final Map<String, dynamic> object;
  final T Function(Map<String, dynamic>) fromJson;

  _ParseObjectParams(this.object, this.fromJson);
}

T _parseObjectInIsolate<T>(_ParseObjectParams<T> params) {
  return params.fromJson(params.object);
}

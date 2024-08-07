
import 'dart:convert';

extension JsonCodecExt on JsonCodec {

  static T? parseInstanceFrom<T>(Map<String, dynamic> jsonMap, {required String key, required T? Function(Map<String, dynamic> jsonMap) parser}) {
    if (!jsonMap.containsKey(key) || jsonMap[key] is Map == false) {
      return null;
    }
    final Map<String, dynamic> map = Map.from(jsonMap[key]);
    final parsed = parser(map);

    return parsed;
  }

  static List<T> parseArrayFrom<T>(Map<String, dynamic> jsonMap, {required String key, required T? Function(Map<String, dynamic> jsonMap) parser}) {
    if (!jsonMap.containsKey(key) || jsonMap[key] is List == false) {
      return [];
    }
    final List<dynamic> arr = List.from(jsonMap[key]);
    final List<T> res = [];
    for (final item in arr) {
      if (item is Map == false) {
        continue;
      }
      final Map<String, dynamic> map = Map.from(item);
      final parsed = parser(map);
      if (parsed == null) {
        continue;
      }
      res.add(parsed);
    }
    if (res.length != arr.length) {
      print("JSON map parsing fail: parsed array length is " + res.length.toString() + ";  expected length is " + arr.length.toString() +"; Key is " + key);
    }

    return res;
  }

  static bool? tryParseBoolFrom(Map<String, dynamic> jsonMap, {required String key}) {
    if (!jsonMap.containsKey(key)) {
      return null;
    }
    final dynVal = jsonMap[key];
    if (dynVal is bool) {
      return dynVal;
    } else if (dynVal is int) {
      final int intVal = dynVal;
      if (intVal == 0) {
        return false;
      } else if (intVal == 1) {
        return true;
      }
    } else if (dynVal is double) {
      final double doubleVal = dynVal;
      if (doubleVal == 0.0 || doubleVal.floor() == 0) {
        return false;
      } else if (doubleVal == 1.0 || doubleVal.floor() == 1) {
        return true;
      }
    } else if (dynVal is String) {
      final String strVal = dynVal;
      final bParsed = bool.tryParse(strVal.toLowerCase());
      if (bParsed != null) {
        return bParsed;
      }
      final iParsed = int.tryParse(strVal);
      if (iParsed != null) {
        final Map<String, dynamic> map = {
          key: iParsed
        };
        return tryParseBoolFrom(map, key: key);
      }
    }
    return null;
  }

  static double? tryParseDoubleFrom(Map<String, dynamic> jsonMap, {required String key}) {
    if (!jsonMap.containsKey(key)) {
      return null;
    }
    final dynVal = jsonMap[key];
    if (dynVal is double) {
      return dynVal;
    } else if (dynVal is int) {
      final int intVal = dynVal;
      return intVal.toDouble();
    } else if (dynVal is String) {
      final doubleVal = double.tryParse(dynVal);
      if (doubleVal != null) {
        return doubleVal;
      } else {
        final String strVal = dynVal.replaceAll(',', '.');
        final parsed = double.tryParse(strVal);
        if (parsed != null) {
          return parsed;
        }
      }
      final intVal = tryParseIntFrom(jsonMap, key: key);
      if (intVal != null) {
        return intVal.toDouble();
      }
    }
    print("JSON double parsing fail from " + key + ":" + dynVal.toString());

    return null;
  }

  static int? tryParseIntFrom(Map<String, dynamic> jsonMap, {required String key, int? radix}) {
    if (!jsonMap.containsKey(key)) {
      return null;
    }
    final dynVal = jsonMap[key];
    if (dynVal is int) {
      return dynVal;
    } else if (dynVal is String) {
      final parsedVal = int.tryParse(dynVal, radix: radix);
      return parsedVal;
    }
    print("JSON int parsing fail from " + key + ":" + dynVal.toString());

    return null;
  }

  List<T> arrayFrom<T>(Map<String, dynamic> jsonMap, {required String key, required T? Function(Map<String, dynamic> jsonMap) parser}) {
    return JsonCodecExt.parseArrayFrom(jsonMap, key: key, parser: parser);
  }

  T? instanceFrom<T>(Map<String, dynamic> jsonMap, {required String key, required T? Function(Map<String, dynamic> jsonMap) parser}) {
    return JsonCodecExt.parseInstanceFrom(jsonMap, key: key, parser: parser);
  }

  bool? tryGetBoolFrom(Map<String, dynamic> jsonMap, {required String key}) {
    return JsonCodecExt.tryParseBoolFrom(jsonMap, key: key);
  }

  double? tryGetDoubleFrom(Map<String, dynamic> jsonMap, {required String key}) {
    return JsonCodecExt.tryParseDoubleFrom(jsonMap, key: key);
  }

  int? tryGetIntFrom(Map<String, dynamic> jsonMap, {required String key, int? radix}) {
    return JsonCodecExt.tryParseIntFrom(jsonMap, key: key, radix: radix);
  }
}
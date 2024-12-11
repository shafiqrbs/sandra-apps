import 'package:sandra/app/core/importer.dart';

int? parseIntegers(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is String) {
    return int.tryParse(value);
  } else {
    return 0;
  }
}

double? parseDouble(dynamic value) {
  if (value is double || value is int) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value);
  } else {
    return 0;
  }
}

Color parseColor(dynamic value, Color defaultValue) {
  if (value == null) return defaultValue;
  if (value is Color) return value;
  return Color(int.tryParse(value)!);
}

extension DynamicExtension on dynamic {
  int? toInt() => parseIntegers(this);
  double? toDouble() => parseDouble(this);
}

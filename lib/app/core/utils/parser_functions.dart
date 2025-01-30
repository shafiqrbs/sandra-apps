import 'package:sandra/app/core/importer.dart';

int? parseInteger(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is num) return value.toInt();
  return 0; // Return null instead of 0 for invalid values
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
//
// extension DynamicExtension on dynamic {
//   int? toInt() => parseIntegers(this);
//   double? toDouble() => parseDouble(this);
// }

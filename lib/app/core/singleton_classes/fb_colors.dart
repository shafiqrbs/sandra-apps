import 'package:flutter/material.dart';

class FBColors {
  // Singleton instance
  static final FBColors _instance = FBColors._();

  // Factory constructor to return the singleton instance
  factory FBColors() => _instance;

  // Private constructor
  FBColors._();

  // Deserialize from JSON
  factory FBColors.fromJson(Map<String, dynamic> json) {
    final instance = FBColors();
    json.forEach((key, value) {
      instance.colors[key] = parseColor(value, Colors.blue);
    });
    return instance;
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    colors.forEach((key, value) {
      // json[key] = value.toJson();
    });
    return json;
  }

  // Default colors
  final Map<String, Color> colors = {
    'fillColor': const Color(0xFFF3F3F3),
    'cursorColor': const Color(0xFF202020),
    'prefixIconColor': const Color(0xFFB3261E),
    'suffixIconColor': const Color(0xFFB3261E),
    'clearIconColor': Colors.orange,
    'toolTipColor': Colors.white,
    'tfToolTipIconColor': const Color(0xFFB3261E),
    'toolTipContentColor': Colors.black,
    'validPrefixIconColor': const Color(0xFF989898),
    'validSuffixIconColor': const Color(0xFF989898),
  };

  // Getter for colors
  Color get fillColor => colors['fillColor']!;
  Color get cursorColor => colors['cursorColor']!;
  Color get prefixIconColor => colors['prefixIconColor']!;
  Color get suffixIconColor => colors['suffixIconColor']!;
  Color get clearIconColor => colors['clearIconColor']!;
  Color get toolTipColor => colors['toolTipColor']!;
  Color get tfToolTipIconColor => colors['tfToolTipIconColor']!;
  Color get toolTipContentColor => colors['toolTipContentColor']!;
  Color get validPrefixIconColor => colors['validPrefixIconColor']!;
  Color get validSuffixIconColor => colors['validSuffixIconColor']!;

  //setter for colors
  set fillColor(Color value) => colors['fillColor'] = value;
  set cursorColor(Color value) => colors['cursorColor'] = value;
  set prefixIconColor(Color value) => colors['prefixIconColor'] = value;
  set suffixIconColor(Color value) => colors['suffixIconColor'] = value;
  set clearIconColor(Color value) => colors['clearIconColor'] = value;
  set toolTipColor(Color value) => colors['toolTipColor'] = value;
  set tfToolTipIconColor(Color value) => colors['tfToolTipIconColor'] = value;
  set toolTipContentColor(Color value) => colors['toolTipContentColor'] = value;
  set validPrefixIconColor(Color value) =>
      colors['validPrefixIconColor'] = value;
  set validSuffixIconColor(Color value) =>
      colors['validSuffixIconColor'] = value;

  static Color parseColor(dynamic value, Color defaultValue) {
    if (value == null) return defaultValue;
    if (value is Color) return value;
    return Color(int.tryParse(value)!);
  }
}

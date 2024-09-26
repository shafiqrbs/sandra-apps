import 'package:flutter/material.dart';

class ColorSchema2 {
  // Factory constructor to return the singleton instance
  factory ColorSchema2() => _instance;

  // Private constructor
  ColorSchema2._();

  // Singleton instance
  static final ColorSchema2 _instance = ColorSchema2._();

  // Primary color
  Color? primaryColor900;
  Color? primaryColor800;
  Color? primaryColor700;
  Color? primaryColor600;
  Color? primaryColor500;
  Color? primaryColor400;
  Color? primaryColor300;
  Color? primaryColor200;
  Color? primaryColor100;
  Color? primaryColor50;

  // Secondary color
  Color? secondaryColor900;
  Color? secondaryColor800;
  Color? secondaryColor700;
  Color? secondaryColor600;
  Color? secondaryColor500;
  Color? secondaryColor400;
  Color? secondaryColor300;
  Color? secondaryColor200;
  Color? secondaryColor100;
  Color? secondaryColor50;

  // Method to update the color schema
  factory ColorSchema2.fromJson(Map<String, dynamic> json) {
    T parseColor<T>(
      dynamic value,
    ) {
      return Color(int.tryParse(value)!) as T;
    }

    return ColorSchema2()
      ..primaryColor900 = parseColor(json['primary_color_900'])
      ..primaryColor800 = parseColor(json['primary_color_800'])
      ..primaryColor700 = parseColor(json['primary_color_700'])
      ..primaryColor600 = parseColor(json['primary_color_600'])
      ..primaryColor500 = parseColor(json['primary_color_500'])
      ..primaryColor400 = parseColor(json['primary_color_400'])
      ..primaryColor300 = parseColor(json['primary_color_300'])
      ..primaryColor200 = parseColor(json['primary_color_200'])
      ..primaryColor100 = parseColor(json['primary_color_100'])
      ..primaryColor50 = parseColor(json['primary_color_50'])
      ..secondaryColor900 = parseColor(json['secondary_color_900'])
      ..secondaryColor800 = parseColor(json['secondary_color_800'])
      ..secondaryColor700 = parseColor(json['secondary_color_700'])
      ..secondaryColor600 = parseColor(json['secondary_color_600'])
      ..secondaryColor500 = parseColor(json['secondary_color_500'])
      ..secondaryColor400 = parseColor(json['secondary_color_400'])
      ..secondaryColor300 = parseColor(json['secondary_color_300'])
      ..secondaryColor200 = parseColor(json['secondary_color_200'])
      ..secondaryColor100 = parseColor(json['secondary_color_100'])
      ..secondaryColor50 = parseColor(json['secondary_color_50']);
  }
}

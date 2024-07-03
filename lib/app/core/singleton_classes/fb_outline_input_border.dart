import 'package:flutter/material.dart';
import '/app/core/extensions/outline_input_border_extensions.dart';

class FBOutlineInputBorder {
  static final FBOutlineInputBorder _instance = FBOutlineInputBorder._();

  factory FBOutlineInputBorder() => _instance;

  FBOutlineInputBorder._();

  // Deserialize from JSON
  factory FBOutlineInputBorder.fromJson(Map<String, dynamic> json) {
    final instance = FBOutlineInputBorder();
    json.forEach(
      (key, value) {
        if (value is Map<String, dynamic>) {
          instance.__outLineInputBorders__[key] =
              OutlineInputBorderExtensions.fromJson(value);
        }
      },
    );
    return instance;
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    __outLineInputBorders__.forEach((key, value) {
      // json[key] = value.toJson();
    });
    return json;
  }

  // Default outline input borders
  final Map<String, OutlineInputBorder> __outLineInputBorders__ = {
    'enabledBorder': OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFE3E0E0)),
      borderRadius: BorderRadius.circular(4),
    ),
    'focusedBorder': OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xFFCFCFCF),
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    'focusedErrorBorder': OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xFFB3261E),
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    'disabledBorder': OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xFF202020),
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    'errorBorder': OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xFFB3261E),
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    'border': OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color(0xFF202020),
      ),
      borderRadius: BorderRadius.circular(4),
    ),
  };

  // getters
  OutlineInputBorder get border => __outLineInputBorders__['border']!;
  OutlineInputBorder get enabledBorder =>
      __outLineInputBorders__['enabledBorder']!;
  OutlineInputBorder get focusedBorder =>
      __outLineInputBorders__['focusedBorder']!;
  OutlineInputBorder get focusedErrorBorder =>
      __outLineInputBorders__['focusedErrorBorder']!;
  OutlineInputBorder get disabledBorder =>
      __outLineInputBorders__['disabledBorder']!;
  OutlineInputBorder get errorBorder => __outLineInputBorders__['errorBorder']!;

  //setters
  set border(OutlineInputBorder value) =>
      __outLineInputBorders__['border'] = value;
  set enabledBorder(OutlineInputBorder value) =>
      __outLineInputBorders__['enabledBorder'] = value;
  set focusedBorder(OutlineInputBorder value) =>
      __outLineInputBorders__['focusedBorder'] = value;
  set focusedErrorBorder(OutlineInputBorder value) =>
      __outLineInputBorders__['focusedErrorBorder'] = value;
  set disabledBorder(OutlineInputBorder value) =>
      __outLineInputBorders__['disabledBorder'] = value;
  set errorBorder(OutlineInputBorder value) =>
      __outLineInputBorders__['errorBorder'] = value;
}

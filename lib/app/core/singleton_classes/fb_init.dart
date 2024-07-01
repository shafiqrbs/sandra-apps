import '/app/core/utils/responsive.dart';

import 'fb_colors.dart';
import 'fb_outline_input_border.dart';
import 'fb_typography.dart';

class FBInit {
  static final FBInit _fbInit = FBInit._();
  factory FBInit() => _fbInit;
  FBInit._();

  double? tfHeight = 5.ph;
  double? tfWidth = 300;
  double? tfIconSize = 24;

  FBColors fbColors = FBColors();
  FBTypography fbTypography = FBTypography();
  FBOutlineInputBorder fbOutlineInputBorder = FBOutlineInputBorder();

  // Deserialize from JSON
  factory FBInit.fromJson(Map<String, dynamic> json) {
    final instance = FBInit();

    instance.tfHeight = json['tfHeight'] == null
        ? 5.42.ph
        : (json['tfHeight'] as num).toDouble();
    instance.tfWidth = (json['tfWidth'] as num).toDouble();

    if (json.containsKey('fbColors')) {
      instance.fbColors = FBColors.fromJson(json['fbColors']);
    }
    if (json.containsKey('fbTypography')) {
      instance.fbTypography = FBTypography.fromJson(json['fbTypography']);
    }
    if (json.containsKey('fbOutlineInputBorder')) {
      instance.fbOutlineInputBorder =
          FBOutlineInputBorder.fromJson(json['fbOutlineInputBorder']);
    }

    return instance;
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['fbTypography'] = fbTypography.toJson();
    json['fbOutlineInputBorder'] = fbOutlineInputBorder.toJson();
    json['fbColors'] = fbColors.toJson();
    return json;
  }
}

import 'dart:ui';

import 'package:flutter/animation.dart';

mixin AppColorMixin {
  Color get primaryColor => const Color(0xFF5568FE);
  Color get secondaryColor => const Color(0xFF98C1D9);
  Color get accentColor => const Color(0xFFEE6C4D);
  Color get backgroundColor => const Color(0xFFE0FBFC);
  Color get textColor => const Color(0xFF293241);
  Color get textColorLight => const Color(0xFF98C1D9);
  Color get textColorDark => const Color(0xFF3D5A80);
  Color get textColorAccent => const Color(0xFFEE6C4D);
  Color get textColorWhite => const Color(0xFFFFFFFF);
  Color get textColorBlack => const Color(0xFF000000);
  Color get textColorGrey => const Color(0xFFA0A0A0);

  Color parseColor(String color) {
    return Color(
      int.parse(
        color.replaceAll('#', '0xFF'),
      ),
    );
  }
}

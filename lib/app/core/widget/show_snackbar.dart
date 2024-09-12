import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/quick_navigation_button.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

SnackbarController showSnackBar({
  required String message,
  required SnackBarType type,
  String? title,
  Color? backgroundColor,
  EdgeInsets? margin,
  double? borderRadius,
}) {
  // switch case
  switch (type) {
    case SnackBarType.success:
      return Get.snackbar(
        title ?? appLocalization.success,
        message,
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorText: Colors.white,
        icon: Icon(
          TablerIcons.circle_check,
          color: colors.backgroundColor,
          size: 18,
        ),
        backgroundColor: backgroundColor ?? colors.solidLiteGreenColor,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
        padding: const EdgeInsets.all(4),
      );
    case SnackBarType.error:
      return Get.snackbar(
        title ?? appLocalization.error,
        message,
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorText: Colors.white,
        icon: Icon(
          TablerIcons.exclamation_circle,
          color: colors.backgroundColor,
          size: 18,
        ),
        backgroundColor: backgroundColor ?? colors.solidRedColor,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
        padding: const EdgeInsets.all(4),
      );
    case SnackBarType.warning:
      return Get.snackbar(
        title ?? appLocalization.notice,
        message,
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorText: Colors.black,
        icon: Icon(
          TablerIcons.alert_triangle,
          color: colors.backgroundColor,
          size: 18,
        ),
        backgroundColor: backgroundColor ?? colors.solidYellowColor,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
        padding: const EdgeInsets.all(4),
      );
    case SnackBarType.info:
      return Get.snackbar(
        title ?? appLocalization.info,
        message,
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorText: Colors.white,
        icon: Icon(
          TablerIcons.info_circle,
          color: colors.backgroundColor,
          size: 18,
        ),
        backgroundColor: backgroundColor ?? colors.solidSkyBlueColor,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
        padding: const EdgeInsets.all(4),
      );

    default:
      return Get.snackbar(
        title ?? appLocalization.success,
        message,
        backgroundColor: backgroundColor ?? colors.primaryColor50,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
      );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/quick_navigation_button.dart';

enum SnackBarType {
  success,
  error,
  warning,
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
        backgroundColor: backgroundColor ?? colors.primaryColor50,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
      );
    case SnackBarType.error:
      return Get.snackbar(
        title ?? appLocalization.error,
        message,
        backgroundColor: backgroundColor ?? colors.primaryColor50,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
      );
    case SnackBarType.warning:
      return Get.snackbar(
        title ?? appLocalization.alert,
        message,
        backgroundColor: backgroundColor ?? colors.primaryColor50,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
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

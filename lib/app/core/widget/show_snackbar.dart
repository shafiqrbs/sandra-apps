import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';

SnackbarController showSnackBar({
  required String message,
  String? title,
  Color? backgroundColor,
  EdgeInsets? margin,
  double? borderRadius,
}) {
  return Get.snackbar(
    title ?? appLocalization.requiredField,
    message,
    backgroundColor: backgroundColor ?? Colors.white,
    margin: margin ?? const EdgeInsets.all(10),
    borderRadius: borderRadius ?? 4,
  );
}

import 'package:sandra/app/core/importer.dart';

import '/app/core/utils/style_function.dart';

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
        //duration: const Duration(seconds: 120),
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
        icon: const Icon(
          TablerIcons.circle_check,
          color: Colors.white,
          size: 18,
        ),
        backgroundColor: backgroundColor ?? colors.solidBlueColor,
        margin: margin ?? const EdgeInsets.all(10),
        borderRadius: borderRadius ?? 4,
        padding: const EdgeInsets.all(4),
      );
    case SnackBarType.error:
      return Get.snackbar(
        title ?? appLocalization.error,
        message,
        //duration: const Duration(seconds: 120),
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorText: Colors.white,
        icon: const Icon(
          TablerIcons.exclamation_circle,
          color: Colors.white,
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
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorText: Colors.white,
        icon: const Icon(
          TablerIcons.alert_triangle,
          color: Colors.white,
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
        icon: const Icon(
          TablerIcons.info_circle,
          color: Colors.white,
          size: 18,
        ),
        backgroundColor: backgroundColor ?? colors.solidGreenColor,
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

import 'package:flutter/material.dart';
import '/app/core/singleton_classes/color_schema.dart';

import '/app/core/utils/responsive.dart';
import '/app/core/values/app_dimension.dart';
import 'common_text.dart';
import 'draw_icon.dart';

class AppBarButton extends StatelessWidget with AppDimension {
  final String? buttonName;
  final Color? buttonTextColor;
  final Color? buttonBGColor;
  final Color? iconColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback onTap;
  final bool? isOutline;

  AppBarButton({
    required this.buttonName,
    required this.onTap,
    super.key,
    this.buttonTextColor,
    this.iconColor,
    this.buttonBGColor,
    this.leftIcon,
    this.rightIcon,
    this.isOutline,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: buttonBGColor ??
              ((isOutline ?? false)
                  ? colors.backgroundColor
                  : colors.primaryBaseColor),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: 10,
          right: 10,
        ),
        //width: 40,
        //height: 28,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null)
              DrawIcon(
                icon: leftIcon!,
                color: iconColor ??
                    (isOutline ?? false
                        ? colors.primaryBaseColor
                        : colors.backgroundColor),
              ),
            if (buttonName != null)
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: CommonText(
                  text: buttonName!,
                  fontWeight: FontWeight.w500,
                  fontSize: mediumButtonTFSize,
                  textColor: buttonTextColor ??
                      (isOutline ?? false
                          ? colors.primaryBaseColor
                          : colors.backgroundColor),
                ),
              ),
            if (rightIcon != null)
              DrawIcon(
                icon: rightIcon!,
                color: iconColor ??
                    (isOutline ?? false
                        ? colors.primaryBaseColor
                        : colors.backgroundColor),
              ),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        //height: 6.ph,
        //width: 10.pw,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: buttonBGColor ??
              ((isOutline ?? false)
                  ? colors.backgroundColor
                  : colors.primaryBaseColor),
          borderRadius: BorderRadius.circular(
            containerBorderRadius,
          ),
          border: (isOutline ?? false)
              ? Border.all(
                  color: colors.primaryBaseColor,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null)
              DrawIcon(
                icon: leftIcon!,
                color: (isOutline ?? false)
                    ? colors.primaryBaseColor
                    : colors.backgroundColor,
              ),
            if (buttonName != null)
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: CommonText(
                  text: buttonName!,
                  fontWeight: FontWeight.w500,
                  fontSize: mediumButtonTFSize,
                  textColor: (isOutline ?? false)
                      ? colors.primaryBaseColor
                      : colors.backgroundColor,
                ),
              ),
            if (rightIcon != null)
              DrawIcon(
                icon: rightIcon!,
                color: (isOutline ?? false)
                    ? colors.primaryBaseColor
                    : colors.backgroundColor,
              ),
          ],
        ),
      ),
    );
  }
}
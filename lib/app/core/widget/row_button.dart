import 'package:flutter/material.dart';
import '/app/core/singleton_classes/color_schema.dart';

import '/app/core/utils/responsive.dart';
import '/app/core/values/app_dimension.dart';
import 'common_text.dart';
import 'draw_icon.dart';

class RowButton extends StatelessWidget with AppDimension {
  final String? buttonName;
  final Color? buttonTextColor;
  final Color? buttonBGColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback onTap;
  final bool? isOutline;

  RowButton({
    required this.buttonName,
    required this.onTap,
    super.key,
    this.buttonTextColor,
    this.buttonBGColor,
    this.leftIcon,
    this.rightIcon,
    this.isOutline,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 5.ph,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: buttonBGColor ??
                ((isOutline ?? false)
                    ? colors.whiteColor
                    : colors.primaryColor500),
            borderRadius: BorderRadius.circular(
              containerBorderRadius,
            ),
            border: (isOutline ?? false)
                ? Border.all(
                    color: colors.primaryColor500,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leftIcon != null)
                DrawIcon(
                  icon: leftIcon!,
                  color: buttonTextColor ??
                      ((isOutline ?? false)
                          ? colors.primaryColor500
                          : colors.whiteColor),
                  size: 20,
                ),
              if (buttonName != null)
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: CommonText(
                    text: buttonName!,
                    fontWeight: FontWeight.w400,
                    fontSize: paragraphTFSize,
                    textColor: buttonTextColor ??
                        ((isOutline ?? false)
                            ? colors.primaryColor500
                            : colors.whiteColor),
                  ),
                ),
              if (rightIcon != null)
                DrawIcon(
                  icon: rightIcon!,
                  color: (isOutline ?? false)
                      ? colors.primaryColor500
                      : colors.whiteColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

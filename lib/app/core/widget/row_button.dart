import 'package:flutter/material.dart';
import '/app/core/singleton_classes/color_schema.dart';

import '/app/core/utils/responsive.dart';
import '/app/core/values/app_dimension.dart';
import 'common_text.dart';
import 'draw_icon.dart';

class RowButton extends StatelessWidget {
  final String buttonName;
  final Color? buttonTextColor;
  final Color? buttonBGColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback onTap;
  final bool? isOutline;

  const RowButton({
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
    final appDimension = AppDimension();
    final colors = ColorSchema();

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 6.ph,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: buttonBGColor ??
                ((isOutline ?? false)
                    ? colors.backgroundColor
                    : colors.primaryBaseColor),
            borderRadius: BorderRadius.circular(
              appDimension.containerBorderRadius,
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
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: CommonText(
                  text: buttonName,
                  fontWeight: FontWeight.w500,
                  fontSize: appDimension.mediumButtonTFSize,
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
      ),
    );
  }
}

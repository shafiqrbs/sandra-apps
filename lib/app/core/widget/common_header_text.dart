import 'package:flutter/material.dart';

import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/values/app_dimension.dart';

class CommonHeaderText extends StatelessWidget with AppDimension {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final String? header;
  final double? fontSize;
  final Color? textColor;
  final int? flex;
  final Alignment? alignment;

  CommonHeaderText({
    required this.header,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.alignment,
    this.fontSize,
    this.textColor,
    this.flex,
  });

  @override
  Widget build(BuildContext context) {
    final colorSchema = ColorSchema();
    return Expanded(
      flex: flex ?? 2,
      child: Container(
        alignment: alignment ?? Alignment.center,
        padding: padding ??
            const EdgeInsets.only(
              left: 4,
              right: 4,
              top: 2,
              bottom: 2,
            ),
        margin: margin ??
            const EdgeInsets.only(
              left: 4,
              right: 4,
            ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            containerBorderRadius,
          ),
        ),
        child: Text(
          header!,
          style: TextStyle(
            fontSize: fontSize ?? 10,
            fontWeight: FontWeight.w500,
            color: textColor ?? colorSchema.primaryTextColor,
          ),
        ),
      ),
    );
  }
}

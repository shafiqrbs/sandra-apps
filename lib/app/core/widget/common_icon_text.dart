import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_widget.dart';

class CommonIconText extends BaseWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLine;
  final TextDecoration? textDecoration;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  CommonIconText({
    required this.text,
    super.key,
    this.textAlign,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textOverflow,
    this.maxLine,
    this.textDecoration,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize ?? 18,
          color: iconColor ?? colors.iconColor,
        ),
        4.width,
        Expanded(
          child: Text(
            text,
            textScaleFactor: 1,
            textAlign: textAlign,
            maxLines: maxLine,
            style: TextStyle(
              color: textColor ?? colors.primaryTextColor,
              fontSize: fontSize ??regularTFSize,
              fontWeight: fontWeight,
              overflow: textOverflow ?? TextOverflow.ellipsis,
              decoration: textDecoration,
            ),
          ),
        ),
      ],
    );
  }
}

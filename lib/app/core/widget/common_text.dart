import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLine;
  final TextDecoration? textDecoration;

  const CommonText({
    required this.text,
    super.key,
    this.textAlign,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textOverflow,
    this.maxLine,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
      ),
    );
  }
}

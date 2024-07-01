import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  String text;
  TextAlign? textAlign;
  Color? textColor;
  double? fontSize;
  FontWeight? fontWeight;
  TextOverflow? textOverflow;
  int? maxLine;
  TextDecoration? textDecoration;

   CommonText({
    required this.text, super.key,
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

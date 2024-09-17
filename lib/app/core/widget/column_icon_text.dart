import 'package:flutter/material.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/singleton_classes/color_schema.dart';

class ColumnIconText extends BaseWidget {
  final bool isSelected;
  final String text;
  final Function()? onTap;
  final IconData? icon;

  ColumnIconText({
    required this.isSelected,
    required this.text,
    required this.onTap,
    required this.icon,
    super.key,
  });
  final colorSchema = ColorSchema();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
           containerBorderRadius,
          ),
          border: Border.all(
            color:
                isSelected ? colorSchema.borderColor : colorSchema.borderColor,
          ),
          color: isSelected ? colorSchema.primaryColor400 : Colors.transparent,
        ),
        child: Column(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: isSelected ? Colors.black : colorSchema.primaryColor100,
                size: 24,
              ),
            Text(
              text,
              style: TextStyle(
                fontSize:mediumTFSize,
                color: isSelected ? Colors.black : colorSchema.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/singleton_classes/fb_colors.dart';
import '/app/core/singleton_classes/fb_outline_input_border.dart';
import '/app/core/singleton_classes/fb_typography.dart';
import '/app/core/values/app_dimension.dart';

final appDimension = AppDimension();
final colors = ColorSchema();

InputDecoration getInputDecoration({
  required String hint,
}) {
  final colorSchema = ColorSchema();
  return InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
    hintText: hint,
    hintStyle: TextStyle(
      color: colorSchema.formBaseHintTextColor,
    ),
    labelStyle: TextStyle(
      color: colorSchema.formLabelColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    filled: false,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colorSchema.formBaseBorderColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colorSchema.formBaseBorderColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colorSchema.formBaseBorderColor,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: colorSchema.formBaseBorderColor,
      ),
    ),
  );
}

InputDecoration inputDecorationAppbarSearch({
  required String hint,
  required TextEditingController textEditingController,
  required bool isSHowSuffixIcon,
  required bool isSHowPrefixIcon,
  IconData? prefix,
  Widget? suffix,
  Function()? onTap,
  Function()? prefixOnTap,
}) {
  return InputDecoration(
    suffixIcon: isSHowSuffixIcon
        ? suffix
        : const Icon(
            MdiIcons.magnify,
            color: Color(0xFFd8c8c3),
          ),
    prefixIcon: isSHowPrefixIcon
        ? IconButton(
            icon: Icon(
              prefix,
              color: Colors.grey,
              size: 22,
            ),
            onPressed: prefixOnTap,
          )
        : const Icon(
            MdiIcons.cloudSearch,
          ),
    prefixIconConstraints: const BoxConstraints(),
    contentPadding: EdgeInsets.zero,
    //contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical:10), // Adjust the padding as needed
    hintText: hint.tr,
    hintStyle: TextStyle(
      fontSize: appDimension.regularTFSize,
      color: colors.formBaseHintTextColor,
    ), // Optional hint text
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        appDimension.containerBorderRadius,
      ), // Adjust the border radius as needed
      borderSide: BorderSide(
        color: colors.borderColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        appDimension.containerBorderRadius,
      ), // Adjust the border radius as needed
      borderSide: BorderSide(
        color: colors.borderColor,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        appDimension.containerBorderRadius,
      ),
      borderSide: BorderSide(
        color: colors.borderColor,
      ),
    ),
  );
}

InputDecoration formBuilderInputDecorationWithIcon({
  required String hint,
  required TextEditingController textEditingController,
  required bool isShowClearIcon,
  bool? isShowToolTip,
  bool? isValid,
  String? toolTipContent,
  Color? toolTipContentColor,
  Color? toolTipColor,
  Color? toolTipIconColor,
  Color? prefixIconColor,
  Color? validPrefixIconColor,
  Color? validSuffixIconColor,
  Color? suffixIconColor,
  IconData? toolTipIcon,
  IconData? prefix,
  IconData? suffix,
  EdgeInsets? contentPadding,
  double? prefixIconSize,
  double? suffixIconSize,
  TextStyle? hintTextStyle,
  TextStyle? toolTipTextStyle,
  OutlineInputBorder? border,
  OutlineInputBorder? enabledBorder,
  OutlineInputBorder? focusedBorder,
  OutlineInputBorder? errorBorder,
  OutlineInputBorder? focusedErrorBorder,
  OutlineInputBorder? disabledBorder,
  Function()? onTap,
}) {
  return InputDecoration(
    contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(8, 8, 8, 0),
    hintText: hint,
    hintStyle: hintTextStyle ?? FBTypography().tfHintTS,

    filled: true,
    fillColor: FBColors().fillColor,
    //don't remove this errorStyle it is used to remove the error text space
    errorStyle: const TextStyle(
      height: 0,
    ),
    enabledBorder: enabledBorder ?? FBOutlineInputBorder().enabledBorder,
    focusedBorder: focusedBorder ?? FBOutlineInputBorder().focusedBorder,
    errorBorder: errorBorder ?? FBOutlineInputBorder().errorBorder,
    focusedErrorBorder:
        focusedErrorBorder ?? FBOutlineInputBorder().focusedErrorBorder,
    disabledBorder: disabledBorder ?? FBOutlineInputBorder().disabledBorder,
    border: border ?? FBOutlineInputBorder().border,
    prefixIcon: prefix == null
        ? null
        : Icon(
            prefix,
            size: prefixIconSize ?? FBTypography().tfLabelTS.fontSize,
            color: isValid ?? false
                ? validPrefixIconColor ?? FBColors().validPrefixIconColor
                : prefixIconColor ?? FBColors().prefixIconColor,
          ),
    prefixIconConstraints: const BoxConstraints(
      minWidth: 36,
    ),
    suffixIcon: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isShowClearIcon
            ? InkWell(
                onTap: onTap,
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Icon(
                    TablerIcons.x,
                    size: suffixIconSize ?? FBTypography().tfLabelTS.fontSize,
                    color: suffixIconColor ?? FBColors().suffixIconColor,
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.only(right: 12),
                child: Icon(
                  suffix,
                  size: suffixIconSize ?? FBTypography().tfLabelTS.fontSize,
                  color: isValid ?? false
                      ? validSuffixIconColor ?? FBColors().validSuffixIconColor
                      : suffixIconColor ?? FBColors().suffixIconColor,
                ),
              ),
        isShowToolTip ?? false
            ? Container(
                margin: const EdgeInsets.only(right: 12),
                child: SuperTooltip(
                  content: Text(
                    toolTipContent!,
                    style: toolTipTextStyle ?? FBTypography().toolTipTs,
                  ),
                  arrowTipDistance: 10,
                  arrowLength: 8,
                  arrowBaseWidth: 8,
                  //right: -16,
                  hideTooltipOnTap: true,
                  //elevation: 0,
                  hasShadow: false,
                  backgroundColor: toolTipColor ?? FBColors().toolTipColor,
                  borderRadius: 4,
                  barrierColor: Colors.transparent,
                  child: Icon(
                    toolTipIcon ?? Icons.info_outline,
                    color: toolTipIconColor ?? FBColors().tfToolTipIconColor,
                    size: FBTypography().tfLabelTS.fontSize,
                  ),
                ),
              )
            : Container(),
      ],
    ),
    suffixIconConstraints: const BoxConstraints(),
  );
}

InputDecoration inputDecorationSearch({
  required String hint,
  required TextEditingController textEditingController,
  required bool isSHowSuffixIcon,
  required bool isSHowPrefixIcon,
  double? borderRaidus,
  IconData? prefix,
  IconData? suffix,
  Function()? onTap,
  Function()? prefixOnTap,
}) {
  return InputDecoration(
    suffixIcon: isSHowSuffixIcon
        ? IconButton(
            icon: Icon(
              Icons.close,
              color: const Color(0xfffc1919).withOpacity(.5),
              size: 18,
            ),
            onPressed: onTap,
          )
        : null,
    prefixIcon: isSHowPrefixIcon
        ? IconButton(
            icon: Icon(
              prefix,
              color: const Color(0xFFd8c8c3),
              size: 18,
            ),
            onPressed: prefixOnTap,
          )
        : const Icon(
            MdiIcons.magnify,
            color: Color(0xFFd8c8c3),
          ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 10,
    ), // Adjust the padding as needed
    hintText: hint.tr,
    hintStyle: TextStyle(
      fontSize: 16,
      color: Colors.grey.withOpacity(.5),
    ), // Optional hint text
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        borderRaidus ?? 4,
      ),
      // Adjust the border radius as needed
      borderSide: const BorderSide(color: Color(0xFFece2d9)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(
        color: Color(0xFFf5edeb),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(
        color: Color(0xFFf5edeb),
      ),
    ),
  );
}

BoxDecoration formBuilderBoxDecoration({
  required Color color,
}) {
  return BoxDecoration(
    color: color,
  );
}

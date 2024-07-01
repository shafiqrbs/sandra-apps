import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/singleton_classes/fb_init.dart';
import 'package:getx_template/app/core/utils/responsive.dart';
import 'package:nb_utils/nb_utils.dart';

const TextInputType number = TextInputType.number;
const TextInputType text = TextInputType.text;
const TextInputType email = TextInputType.emailAddress;

const TextInputAction next = TextInputAction.next;
const TextInputAction done = TextInputAction.done;

class FBString extends StatelessWidget {
  //Strings
  String? label;
  String? example;
  String? hint;
  String? errorMsg;
  String? toolTipContent;

  //EdgeInsets
  EdgeInsets? padding;
  EdgeInsets? contentPadding;

  //TextStyles
  TextStyle? labelTextStyle;
  TextStyle? exampleTextStyle;
  TextStyle? errorMsgTextStyle;
  TextStyle? hintTextStyle;
  TextStyle? inputTextStyle;
  TextStyle? toolTipTextStyle;

  //OutlineInputBorder
  OutlineInputBorder? border;
  OutlineInputBorder? enabledBorder;
  OutlineInputBorder? focusedBorder;
  OutlineInputBorder? errorBorder;
  OutlineInputBorder? focusedErrorBorder;
  OutlineInputBorder? disabledBorder;

  //Colors
  Color? fillColor;
  Color? cursorColor;
  Color? toolTipContentColor;
  Color? toolTipColor;
  Color? toolTipIconColor;
  Color? prefixIconColor;

  //IconData
  IconData? toolTipIcon;
  IconData? preFixIcon;
  IconData? suffixIcon;

  //Doubles
  double? textFieldHeight;
  double? textFieldWidth;
  double? prefixIconSize;

  //ints
  int? lines;

  //bools
  bool isRequired;
  bool? isShowToolTip;
  bool? isReadOnly;

  //decoration
  InputDecoration? decoration;

  //Functions
  Function(String? value)? onChange;

  //TODO: add onClear function
  //Function(String? value)? onClear;

  //controllers
  TextEditingController textController = TextEditingController();

  TextInputType? keyboardType = text;
  TextInputAction? textInputAction = next;

  FBString({
    required this.isRequired,
    required this.textController,
    super.key,
    this.label,
    this.example,
    this.hint,
    this.errorMsg,
    this.toolTipContent,
    this.padding,
    this.contentPadding,
    this.labelTextStyle,
    this.exampleTextStyle,
    this.errorMsgTextStyle,
    this.toolTipTextStyle,
    this.hintTextStyle,
    this.inputTextStyle,
    this.textFieldHeight,
    this.textFieldWidth,
    this.lines,
    this.fillColor,
    this.cursorColor,
    this.toolTipContentColor,
    this.toolTipColor,
    this.toolTipIconColor,
    this.toolTipIcon,
    this.preFixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.prefixIconSize,
    this.isShowToolTip,
    this.isReadOnly,
    this.onChange,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.keyboardType = text,
    this.textInputAction = next,
    this.decoration,
  });

  FBString copyWith({
    String? label,
    String? example,
    String? hint,
    String? errorMsg,
    String? toolTipContent,
    EdgeInsets? padding,
    EdgeInsets? contentPadding,
    TextStyle? labelTextStyle,
    TextStyle? exampleTextStyle,
    TextStyle? errorMsgTextStyle,
    TextStyle? hintTextStyle,
    TextStyle? inputTextStyle,
    TextStyle? toolTipTextStyle,
    OutlineInputBorder? border,
    OutlineInputBorder? enabledBorder,
    OutlineInputBorder? focusedBorder,
    OutlineInputBorder? errorBorder,
    OutlineInputBorder? focusedErrorBorder,
    OutlineInputBorder? disabledBorder,
    Color? fillColor,
    Color? cursorColor,
    Color? toolTipContentColor,
    Color? toolTipColor,
    Color? toolTipIconColor,
    Color? prefixIconColor,
    IconData? toolTipIcon,
    IconData? preFixIcon,
    IconData? suffixIcon,
    double? textFieldHeight,
    double? textFieldWidth,
    double? prefixIconSize,
    int? lines,
    bool? isRequired,
    bool? isShowToolTip,
    bool? isReadOnly,
    InputDecoration? decoration,
    Function(String? value)? onChange,
    TextEditingController? textController,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return FBString(
      label: label ?? this.label,
      example: example ?? this.example,
      hint: hint ?? this.hint,
      errorMsg: errorMsg ?? this.errorMsg,
      toolTipContent: toolTipContent ?? this.toolTipContent,
      padding: padding ?? this.padding,
      contentPadding: contentPadding ?? this.contentPadding,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      exampleTextStyle: exampleTextStyle ?? this.exampleTextStyle,
      errorMsgTextStyle: errorMsgTextStyle ?? this.errorMsgTextStyle,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      toolTipTextStyle: toolTipTextStyle ?? this.toolTipTextStyle,
      border: border ?? this.border,
      enabledBorder: enabledBorder ?? this.enabledBorder,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      focusedErrorBorder: focusedErrorBorder ?? this.focusedErrorBorder,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      fillColor: fillColor ?? this.fillColor,
      cursorColor: cursorColor ?? this.cursorColor,
      toolTipContentColor: toolTipContentColor ?? this.toolTipContentColor,
      toolTipColor: toolTipColor ?? this.toolTipColor,
      toolTipIconColor: toolTipIconColor ?? this.toolTipIconColor,
      prefixIconColor: prefixIconColor ?? this.prefixIconColor,
      toolTipIcon: toolTipIcon ?? this.toolTipIcon,
      preFixIcon: preFixIcon ?? this.preFixIcon,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      textFieldHeight: textFieldHeight ?? this.textFieldHeight,
      textFieldWidth: textFieldWidth ?? this.textFieldWidth,
      prefixIconSize: prefixIconSize ?? this.prefixIconSize,
      lines: lines ?? this.lines,
      isRequired: isRequired ?? this.isRequired,
      isShowToolTip: isShowToolTip ?? this.isShowToolTip,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      decoration: decoration ?? this.decoration,
      onChange: onChange ?? this.onChange,
      textController: textController ?? this.textController,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
    );
  }

  // Existing methods...

  final isFieldValid = true.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          padding: padding ??
              EdgeInsets.symmetric(
                vertical: 0.v,
                horizontal: 0.h,
              ),
          margin: EdgeInsets.symmetric(
            vertical: 0.v,
            horizontal: 0.h,
          ),
          child: Column(
            children: [
              if (label != null || example != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            label ?? '',
                            style: labelTextStyle ?? FBTypography().tfLabelTS,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            example ?? '',
                            style:
                                exampleTextStyle ?? FBTypography().tfExampleTS,
                          ),
                        ),
                      ],
                    ),
                    4.height,
                  ],
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: lines != null && lines! > 1
                          ? null
                          : textFieldHeight ?? FBInit().tfHeight,
                      width: textFieldWidth ?? FBInit().tfWidth,
                      margin: EdgeInsets.zero,
                      child: TextFormField(
                        controller: textController,
                        maxLines: lines ?? 1,
                        cursorColor: FBColors().cursorColor,
                        onChanged: (value) {
                          onChange?.call(value);
                          isFieldValid.refresh();
                        },
                        readOnly: isReadOnly ?? false,
                        decoration: decoration ??
                            formBuilderInputDecorationWithIcon(
                              hint: hint ?? '',
                              hintTextStyle: hintTextStyle,
                              textEditingController: textController,
                              isShowClearIcon:
                                  textController.value.text.isNotEmpty,
                              isShowToolTip: isShowToolTip,
                              toolTipContent: toolTipContent,
                              toolTipContentColor: toolTipContentColor,
                              toolTipColor: toolTipColor,
                              toolTipIcon: toolTipIcon,
                              toolTipIconColor: toolTipIconColor,
                              toolTipTextStyle: toolTipTextStyle,
                              prefixIconColor: prefixIconColor,
                              prefixIconSize: prefixIconSize,
                              isValid: isFieldValid.value,
                              border: border ?? FBOutlineInputBorder().border,
                              enabledBorder: enabledBorder ??
                                  FBOutlineInputBorder().enabledBorder,
                              focusedBorder: focusedBorder ??
                                  FBOutlineInputBorder().focusedBorder,
                              disabledBorder: disabledBorder ??
                                  FBOutlineInputBorder().disabledBorder,
                              errorBorder: errorBorder ??
                                  FBOutlineInputBorder().errorBorder,
                              focusedErrorBorder: focusedErrorBorder ??
                                  FBOutlineInputBorder().focusedErrorBorder,
                              prefix: preFixIcon,
                              suffix: suffixIcon,
                              onTap: () {
                                textController.clear();
                                onChange?.call('');
                                isFieldValid.refresh();
                                //textController.refresh();
                              },
                            ),
                        inputFormatters: const [
                          /*FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9]*$'),
                        ),*/
                        ],
                        keyboardType: keyboardType,
                        textInputAction: textInputAction,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: inputTextStyle ?? FBTypography().tfInputTS,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        validator: (value) {
                          if (isRequired && value.isEmptyOrNull) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                isFieldValid.value = false;
                              },
                            );
                            return '';
                          }
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              isFieldValid.value = true;
                            },
                          );
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              errorMsg != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        !isFieldValid.value ? errorMsg ?? '' : '',
                        style: errorMsgTextStyle ?? FBTypography().tfErrorMsgTS,
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}

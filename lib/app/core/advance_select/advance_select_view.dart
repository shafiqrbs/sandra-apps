import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/singleton_classes/fb_colors.dart';
import '/app/core/singleton_classes/fb_init.dart';
import '/app/core/singleton_classes/fb_outline_input_border.dart';
import '/app/core/singleton_classes/fb_typography.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/fb_string.dart';
import 'advance_select_controller.dart';

class AdvanceSelect<T> extends FormField<T> {
  final ASController<T> controller;
  final String Function(T?) itemToString;
  final bool isRequired;
  final bool isShowSearch;

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
  bool? isShowToolTip;
  bool? isReadOnly;

  //decoration
  InputDecoration? decoration;

  //Functions
  Function(String? value)? onChange;

  //TODO: add onClear function
  //Function(String? value)? onClear;

  //controllers
  TextEditingController? textController = TextEditingController();

  AdvanceSelect({
    required this.isRequired,
    required this.isShowSearch,
    required this.controller,
    required this.itemToString,
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
    this.hintTextStyle,
    this.inputTextStyle,
    this.toolTipTextStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.fillColor,
    this.cursorColor,
    this.toolTipContentColor,
    this.toolTipColor,
    this.toolTipIconColor,
    this.prefixIconColor,
    this.toolTipIcon,
    this.preFixIcon,
    this.suffixIcon,
    this.textFieldHeight,
    this.textFieldWidth,
    this.prefixIconSize,
    this.lines,
    this.isShowToolTip,
    this.isReadOnly,
    this.decoration,
    this.onChange,
    this.textController,
    //this.onClear,
    FormFieldValidator<T>? validator,
  }) : super(
          validator: (value) {
            if (isRequired && controller.selectedValue == null) {
              return 'Please choose an option for $label';
            }
            return validator?.call(value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (state) {
            final isFieldValid = true.obs;

            if (controller.selectedValue != null) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  if (state.mounted) {
                    state.didChange(controller.selectedValue);
                  }
                },
              );
            }
            return Container(
              color: Colors.transparent,
              child: Obx(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      label ?? '',
                                      style: labelTextStyle ??
                                          FBTypography().tfLabelTS,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      example ?? '',
                                      style: exampleTextStyle ??
                                          FBTypography().tfExampleTS,
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
                                height: lines != null && lines > 1 ? null : textFieldHeight ?? FBInit().tfHeight,
                                width: textFieldWidth ?? FBInit().tfWidth,
                                margin: EdgeInsets.zero,
                                child: Stack(
                                  alignment: Alignment.centerRight,

                                  children: [
                                    TextFormField(
                                      controller: TextEditingController(
                                        text: controller.selectedValue == null
                                            ? hint
                                            : itemToString(
                                                controller.selectedValue,
                                              ),
                                      ),
                                      maxLines: lines ?? 1,
                                      cursorColor: FBColors().cursorColor,
                                      onChanged: (value) {
                                        onChange?.call(value);
                                        isFieldValid.refresh();
                                      },
                                      onTap: () {
                                        controller.filteredItems =
                                            controller.items;
                                        showDialog(
                                          context: state.context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              //shadowColor: Colors.transparent,
                                              elevation: 0,
                                              child: Center(
                                                child: Container(
                                                  width: Get.width * 1,
                                                  height: Get.height *
                                                      (controller.items!
                                                                  .length <=
                                                              10
                                                          ? 0.5
                                                          : 0.9),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    //shrinkWrap: true,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Select Anyone ${label ?? ''}',
                                                            style:const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                          ).paddingOnly(
                                                            right: 16,
                                                            top: 16,
                                                            bottom: 16,
                                                            left: 4,
                                                          ),
                                                          IconButton(
                                                            icon:  Icon(
                                                              Icons.close,
                                                              color: colors.primaryBaseColor,
                                                              size: 16,
                                                            ),
                                                            onPressed: () {
                                                              controller
                                                                      .filteredItems =
                                                                  controller
                                                                      .items;
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      if (isShowSearch)
                                                        FBString(
                                                          textController:
                                                              TextEditingController(),
                                                          isRequired: true,
                                                          onChange: (value) {
                                                            controller.search(
                                                              value!,
                                                              itemToString,
                                                            );
                                                          },
                                                          hint: 'search',
                                                          label: '',
                                                          errorMsg: '',
                                                          preFixIcon:
                                                              TablerIcons
                                                                  .search,
                                                        ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: controller
                                                                  .filteredItems
                                                                  ?.length ??
                                                              0,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                controller
                                                                        .selectedValue =
                                                                    controller
                                                                            .filteredItems![
                                                                        index];
                                                                state.didChange(
                                                                  controller
                                                                          .filteredItems![
                                                                      index],
                                                                );
                                                                controller
                                                                        .filteredItems =
                                                                    controller
                                                                        .items;
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: index.isEven
                                                                              ? ColorSchema().evenListColor
                                                                              : ColorSchema().evenListColor.withOpacity(0.6),
                                                                          //color: index.isEven ? Colors.blue : Colors.red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                          bottom:
                                                                              8,
                                                                          top:
                                                                              8,
                                                                          right:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              itemToString(
                                                                                controller.filteredItems![index],
                                                                              ),
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 10.sp,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                            if (controller.selectedValue ==
                                                                                controller.filteredItems![index])
                                                                               Icon(
                                                                                Icons.check,
                                                                                size: 16,
                                                                                color: Colors.red,
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then(
                                          (value) {
                                            if (value != null) {
                                              state.didChange(value);
                                            }
                                          },
                                        );
                                      },
                                      readOnly: true,
                                      decoration: decoration ??
                                          formBuilderInputDecorationWithIcon(
                                            hint: hint ?? '',
                                            hintTextStyle: hintTextStyle,
                                            textEditingController:
                                                textController ??
                                                    TextEditingController(),
                                            isShowClearIcon:
                                                controller.selectedValue !=
                                                    null,
                                            isShowToolTip: isShowToolTip,
                                            toolTipContent: toolTipContent,
                                            toolTipContentColor:
                                                toolTipContentColor,
                                            toolTipColor: toolTipColor,
                                            toolTipIcon: toolTipIcon,
                                            toolTipIconColor: toolTipIconColor,
                                            toolTipTextStyle: toolTipTextStyle,
                                            prefixIconColor: prefixIconColor,
                                            prefixIconSize: prefixIconSize,
                                            isValid: isFieldValid.value,
                                            border: border ??
                                                FBOutlineInputBorder().border,
                                            enabledBorder: enabledBorder ??
                                                FBOutlineInputBorder()
                                                    .enabledBorder,
                                            focusedBorder: focusedBorder ??
                                                FBOutlineInputBorder()
                                                    .focusedBorder,
                                            disabledBorder: disabledBorder ??
                                                FBOutlineInputBorder()
                                                    .disabledBorder,
                                            errorBorder: errorBorder ??
                                                FBOutlineInputBorder()
                                                    .errorBorder,
                                            focusedErrorBorder:
                                                focusedErrorBorder ??
                                                    FBOutlineInputBorder()
                                                        .focusedErrorBorder,
                                            prefix: preFixIcon,
                                            suffix: suffixIcon,
                                            onTap: () {
                                              print('onTap');
                                              controller.clear();
                                              state.didChange(null);
                                              textController?.clear();
                                              onChange?.call('');
                                              isFieldValid.refresh();
                                              //textController.refresh();
                                            },
                                          ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: inputTextStyle ??
                                          (controller.selectedValue == null
                                              ? FBTypography().tfHintTS
                                              : FBTypography().tfInputTS),
                                      onEditingComplete: () {
                                        //FocusScope.of(context).nextFocus();
                                      },
                                      onFieldSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          // FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      validator: (value) {
                                        if (isRequired &&
                                            controller.selectedValue == null) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                            (_) {
                                              isFieldValid.value = false;
                                            },
                                          );
                                          return '';
                                        }
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (_) {
                                            isFieldValid.value = true;
                                          },
                                        );
                                        return null;
                                      },
                                    ),
                                    if (controller.selectedValue == null)
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color:
                                                FBTypography().tfHintTS.color,
                                          ),
                                        ),
                                      ),
                                  ],
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
                                  style: errorMsgTextStyle ??
                                      FBTypography().tfErrorMsgTS,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );

  @override
  CustomDropdownFormFieldState<T> createState() =>
      CustomDropdownFormFieldState<T>();
}

class CustomDropdownFormFieldState<T> extends FormFieldState<T> {
  @override
  AdvanceSelect<T> get widget => super.widget as AdvanceSelect<T>;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

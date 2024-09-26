import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin ShorterEnumMixin {
  //KeyboardType enums

  /// Equivalents to TextInputType.text
  /// Used for text input
  TextInputType get textInputType => TextInputType.text;

  /// Equivalents to TextInputType.number
  /// Used for number input
  TextInputType get numberInputType => TextInputType.number;

  /// Equivalents to TextInputType.datetime
  /// Used for date and time input
  TextInputType get datetimeInputType => TextInputType.datetime;

  /// Equivalents to TextInputType.phone
  /// Used for phone number input
  TextInputType get phoneInputType => TextInputType.phone;

  /// Equivalents to TextInputType.emailAddress
  /// Used for email input
  TextInputType get emailAddressInputType => TextInputType.emailAddress;

  /// Equivalents to TextInputType.url
  /// Used for URL input
  TextInputType get multilineInputType => TextInputType.multiline;

  /// Equivalents to TextInputType.numberWithOptions
  /// Used for number input with options
  //final  numberWithOptionsInputType = TextInputType.numberWithOptions;

  //TextInputAction enums
  /// Equivalents to TextInputAction.done
  /// Used for done action
  TextInputAction get doneInputAction => TextInputAction.done;

  /// Equivalents to TextInputAction.next
  /// Used for next action
  TextInputAction get nextInputAction => TextInputAction.next;

  /// Equivalents to TextInputAction.previous
  /// Used for previous action
  TextInputAction get previousInputAction => TextInputAction.previous;

  /// Equivalents to TextInputAction.search
  /// Used for search action
  TextInputAction get searchInputAction => TextInputAction.search;

  /// Equivalents to TextInputAction.go
  /// Used for go action
  TextInputAction get goInputAction => TextInputAction.go;

  /// Equivalents to TextInputAction.send
  /// Used for send action
  TextInputAction get sendInputAction => TextInputAction.send;

  /// Equivalents to TextInputAction.none
  /// Used for no action
  TextInputAction get noneInputAction => TextInputAction.none;

  //Validation enums

  /// Equivalents to AutoValidateMode.always
  /// Used for always auto validation
  AutovalidateMode get autoValidate => AutovalidateMode.always;

  /// Equivalents to AutoValidateMode.onUserInteraction
  /// Used for auto validation on user interaction
  AutovalidateMode get onUserInteraction => AutovalidateMode.onUserInteraction;

  /// Equivalents to AutoValidateMode.disabled
  /// Used for disabled auto validation
  AutovalidateMode get disabled => AutovalidateMode.disabled;

  //InputFormatters enums

  List<FilteringTextInputFormatter> get integerInputFormatter => [
        FilteringTextInputFormatter.allow(RegExp('^[0-9]*')),
      ];
  List<FilteringTextInputFormatter> get doubleInputFormatter => [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*')),
      ];
  // MainAxisAlignment enums

  /// Equivalents to MainAxisAlignment.start
  /// Aligns widgets at the start of the main axis
  MainAxisAlignment get startMAA => MainAxisAlignment.start;

  ///Equivalents to MainAxisAlignment.end
  /// Aligns widgets at the end of the main axis
  MainAxisAlignment get endMAA => MainAxisAlignment.end;

  /// Equivalents to MainAxisAlignment.center
  /// Aligns widgets at the center of the main axis
  MainAxisAlignment get centerMAA => MainAxisAlignment.center;

  /// Equivalents to MainAxisAlignment.spaceBetween
  /// Spaces widgets evenly along the main axis, distributing any extra space
  /// between the widgets
  MainAxisAlignment get spaceBetweenMAA => MainAxisAlignment.spaceBetween;

  /// Equivalents to MainAxisAlignment.spaceAround
  /// Spaces widgets evenly along the main axis, distributing any extra space
  /// around the widgets
  MainAxisAlignment get spaceAroundMAA => MainAxisAlignment.spaceAround;

  /// Equivalents to MainAxisAlignment.spaceEvenly
  /// Spaces widgets evenly along the main axis, including extra space before
  /// the first widget and after the last widget
  MainAxisAlignment get spaceEvenlyMAA => MainAxisAlignment.spaceEvenly;

  //CrossAxisAlignment enums
  /// Equivalents to CrossAxisAlignment.start
  /// Aligns children to the start of the cross axis
  CrossAxisAlignment get startCAA => CrossAxisAlignment.start;

  /// Equivalents to CrossAxisAlignment.end
  /// Aligns children to the end of the cross axis
  CrossAxisAlignment get endCAA => CrossAxisAlignment.end;

  /// Equivalents to CrossAxisAlignment.center
  /// Aligns children to the center of the cross axis
  CrossAxisAlignment get centerCAA => CrossAxisAlignment.center;

  /// Equivalents to CrossAxisAlignment.stretch
  /// Aligns children to fill the cross axis
  CrossAxisAlignment get stretchCAA => CrossAxisAlignment.stretch;

  /// Equivalents to CrossAxisAlignment.baseline
  /// Aligns children according to their baseline
  CrossAxisAlignment get baselineCAA => CrossAxisAlignment.baseline;

  //MainAxisSize enums

  /// Equivalents to MainAxisSize.min
  /// The minimum size a widget can be
  MainAxisSize get minMAS => MainAxisSize.min;

  /// Equivalents to MainAxisSize.max
  /// The maximum size a widget can be
  MainAxisSize get maxMAS => MainAxisSize.max;

  //TextAlign enums
  TextAlign get leftTA => TextAlign.left;
  TextAlign get rightTA => TextAlign.right;
  TextAlign get centerTA => TextAlign.center;
  TextAlign get justifyTA => TextAlign.justify;
  TextAlign get startTA => TextAlign.start;
  TextAlign get endTA => TextAlign.end;

  //TextDirection enums
  TextDirection get ltrTD => TextDirection.ltr;
  TextDirection get rtlTD => TextDirection.rtl;

  //TextOverflow enums
  TextOverflow get clipTO => TextOverflow.clip;
  TextOverflow get fadeTO => TextOverflow.fade;
  TextOverflow get ellipsisTO => TextOverflow.ellipsis;
  TextOverflow get visibleTO => TextOverflow.visible;

  //WrapAlignment enums
  WrapAlignment get startWA => WrapAlignment.start;
  WrapAlignment get endWA => WrapAlignment.end;
  WrapAlignment get centerWA => WrapAlignment.center;
  WrapAlignment get spaceBetweenWA => WrapAlignment.spaceBetween;
  WrapAlignment get spaceAroundWA => WrapAlignment.spaceAround;
  WrapAlignment get spaceEvenlyWA => WrapAlignment.spaceEvenly;

  //WrapCrossAlignment enums
  WrapCrossAlignment get startWCA => WrapCrossAlignment.start;
  WrapCrossAlignment get endWCA => WrapCrossAlignment.end;
  WrapCrossAlignment get centerWCA => WrapCrossAlignment.center;

  EdgeInsets get zero => EdgeInsets.zero;
}

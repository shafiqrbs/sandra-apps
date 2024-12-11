import 'package:sandra/app/core/importer.dart';
import '/app/core/extensions/text_style_extensions.dart';
import '/app/core/utils/responsive.dart';

class FBTypography {
  static final FBTypography _instance = FBTypography._();

  factory FBTypography() => _instance;

  FBTypography._();

  factory FBTypography.fromJson(Map<String, dynamic> json) {
    final instance = FBTypography();
    json.forEach(
      (key, value) {
        if (value is Map<String, dynamic>) {
          instance.textStyles[key] = TextStyleExtension.fromJson(value);
        }
      },
    );
    return instance;
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    textStyles.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }

  // Default text styles
  final Map<String, TextStyle> textStyles = {
    'titleStyle': const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    'subtitleStyle': const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    'bodyStyle': const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'headline1': const TextStyle(
      fontSize: 96,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    'headline2': const TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'headline3': const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'headline4': const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'headline5': const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'headline6': const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    'subtitle1': const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'subtitle2': const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    'bodyText1': const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'bodyText2': const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'caption': const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    'button': const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    'overline': const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    //Here TS Stand For text style
    'tfLabelTS': TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF2D2D2D),
    ),
    'tfExampleTS': TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF202020),
    ),
    'tfErrorMsgTS': TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFB3261E),
    ),
    'tfHintTS': TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF989898),
    ),
    'tfInputTS': TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF202020),
    ),

    'toolTipTs': TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF202020),
    ),
  };

  // Define your text styles here
  TextStyle get titleStyle => textStyles['titleStyle']!;
  TextStyle get subtitleStyle => textStyles['subtitleStyle']!;
  TextStyle get bodyStyle => textStyles['bodyStyle']!;
  TextStyle get headline1 => textStyles['headline1']!;
  TextStyle get headline2 => textStyles['headline2']!;
  TextStyle get headline3 => textStyles['headline3']!;
  TextStyle get headline4 => textStyles['headline4']!;
  TextStyle get headline5 => textStyles['headline5']!;
  TextStyle get headline6 => textStyles['headline6']!;
  TextStyle get subtitle1 => textStyles['subtitle1']!;
  TextStyle get subtitle2 => textStyles['subtitle2']!;
  TextStyle get bodyText1 => textStyles['bodyText1']!;
  TextStyle get bodyText2 => textStyles['bodyText2']!;
  TextStyle get caption => textStyles['caption']!;
  TextStyle get button => textStyles['button']!;
  TextStyle get overLine => textStyles['overline']!;
  //Here TS Stand For text style
  TextStyle get tfLabelTS => textStyles['tfLabelTS']!;
  TextStyle get tfExampleTS => textStyles['tfExampleTS']!;
  TextStyle get tfErrorMsgTS => textStyles['tfErrorMsgTS']!;
  TextStyle get tfHintTS => textStyles['tfHintTS']!;
  TextStyle get tfInputTS => textStyles['tfInputTS']!;
  TextStyle get toolTipTs => textStyles['toolTipTs']!;

  //setters
  set titleStyle(TextStyle value) => textStyles['titleStyle'] = value;
  set subtitleStyle(TextStyle value) => textStyles['subtitleStyle'] = value;
  set bodyStyle(TextStyle value) => textStyles['bodyStyle'] = value;
  set headline1(TextStyle value) => textStyles['headline1'] = value;
  set headline2(TextStyle value) => textStyles['headline2'] = value;
  set headline3(TextStyle value) => textStyles['headline3'] = value;
  set headline4(TextStyle value) => textStyles['headline4'] = value;
  set headline5(TextStyle value) => textStyles['headline5'] = value;
  set headline6(TextStyle value) => textStyles['headline6'] = value;
  set subtitle1(TextStyle value) => textStyles['subtitle1'] = value;
  set subtitle2(TextStyle value) => textStyles['subtitle2'] = value;
  set bodyText1(TextStyle value) => textStyles['bodyText1'] = value;
  set bodyText2(TextStyle value) => textStyles['bodyText2'] = value;
  set caption(TextStyle value) => textStyles['caption'] = value;
  set button(TextStyle value) => textStyles['button'] = value;
  set overLine(TextStyle value) => textStyles['overline'] = value;
  //Here TS Stand For text style
  set tfLabelTS(TextStyle value) => textStyles['tfLabelTS'] = value;
  set tfExampleTS(TextStyle value) => textStyles['tfExampleTS'] = value;
  set tfErrorMsgTS(TextStyle value) => textStyles['tfErrorMsgTS'] = value;
  set tfHintTS(TextStyle value) => textStyles['tfHintTS'] = value;
  set tfInputTS(TextStyle value) => textStyles['tfInputTS'] = value;
  set toolTipTs(TextStyle value) => textStyles['toolTipTs'] = value;
}

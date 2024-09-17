import 'package:flutter/material.dart';

class ColorSchema {
  Brightness? brightness;

  Color primaryColor = const Color(0xFF00994F);

  Color get primaryColor500 =>
      brightness == Brightness.dark ? Colors.black : const Color(0xFF00994F);

  Color primaryColor900 = const Color(0xFF004021);
  Color primaryColor800 = const Color(0xFF00542B);
  Color primaryColor700 = const Color(0xFF006D38);
  Color primaryColor600 = const Color(0xFF008B48);
  //Color primaryColor500 = const Color(0xFF00994F);
  Color primaryColor400 = const Color(0xFF33AD72);
  Color primaryColor300 = const Color(0xFF54BB89);
  Color primaryColor200 = const Color(0xFF8AD0AE);
  Color primaryColor100 = const Color(0xFFB0DFC8);
  Color primaryColor50 = const Color(0xFFE6F5ED);

  Color secondaryColor = const Color(0xFF30444F);

  Color secondaryColor900 = const Color(0xFF141D21);
  Color secondaryColor800 = const Color(0xFF1A252B);
  Color secondaryColor700 = const Color(0xFF223038);
  Color secondaryColor600 = const Color(0xFF2C3E48);
  Color secondaryColor500 = const Color(0xFF30444F);
  Color secondaryColor400 = const Color(0xFF596972);
  Color secondaryColor300 = const Color(0xFF748289);
  Color secondaryColor200 = const Color(0xFFA0A9AE);
  Color secondaryColor100 = const Color(0xFFBFC5C8);
  Color secondaryColor50 = const Color(0xFFEAECED);

  Color primaryBackgroundColor = const Color(0xffffffff);

  Color colorTwo = const Color(0xff2abba7);

  Color tertiaryBaseColor = const Color(0xFFF7DFBB);
  Color primaryBaseColor = const Color(0xFFC98A69);
  Color primaryLiteColor = const Color(0xffe0b6a5);

  Color iconColor = const Color(0xFFd8c8c3);
  Color iconBackgroundColor = const Color(0xfff0e5e2);
  Color moduleHeaderColor = const Color(0xFFf5edeb);
  Color moduleBodyColor = const Color(0xFFfffbff);
  Color moduleFooterColor = const Color(0xfff6f1f6);
  Color borderColor = const Color(0xFFE3E0E0);
  Color primaryTextColor = const Color(0xFF4d4538);
  Color secondaryTextColor = const Color(0xFF5f5b58);
  Color textFieldColor = const Color(0xFFF3F3F3);
  Color selectedColor = const Color(0xFFF7DFBB);
  Color buttonColor = const Color(0xFFC98A69);

  Color formLabelColor = const Color(0xFF4d4538);
  Color formExampleColor = const Color(0xFF5f5b58);
  Color formErrorMsgColor = const Color(0xfffc1919).withOpacity(.5);
  Color formBaseHintTextColor = Colors.grey.withOpacity(.5);

  Color formClearIconColor = const Color(0xFFB3261E);
  Color formCursorColor = const Color(0xff000000);

  Color formBaseBorderColor = const Color(0xFFece2d9);

  Color evenListColor = const Color(0xffFAF4FB);
  Color oddListColor = const Color(0xFFffffff);

  Color successfulBaseColor = Colors.green;
  Color dangerBaseColor = Colors.red;
  Color dangerLiteColor = Colors.red.withOpacity(.4);

  Color backgroundColor = Colors.white;
  Color defaultFontColor = const Color(0xFF202020);

  Color textColorH6 = Colors.black;

  Color successButtonBorderColor = const Color(0xff157347);

  Color infoButtonFillColor = const Color(0xff31D2F2).withOpacity(.6);
  Color infoButtonIconColor = const Color(0xff000000);

  Color removeButtonFillColor = const Color(0xffBB2D3B).withOpacity(.6);
  Color removeButtonIconColor = const Color(0xffffffff);

  Color editButtonFillColor = const Color(0xff0b64ce).withOpacity(.6);
  Color editButtonIconColor = const Color(0xffffffff);

  Color blueColor = const Color(0xff0d6efd);
  late Color solidBlueColor = blueColor.withOpacity(0.8);
  late Color primaryBlueColor = blueColor.withOpacity(0.4);
  late Color secondaryBlueColor = blueColor.withOpacity(0.2);

  Color redColor = const Color(0xffdc3545);
  late Color solidRedColor = redColor.withOpacity(0.8);
  late Color primaryRedColor = redColor.withOpacity(0.4);
  late Color secondaryRedColor = redColor.withOpacity(0.2);

  Color greenColor = const Color(0xff198754);
  late Color solidGreenColor = greenColor.withOpacity(0.8);
  late Color primaryGreenColor = greenColor.withOpacity(0.4);
  late Color secondaryGreenColor = greenColor.withOpacity(0.2);

  Color yellowColor = const Color(0xffffc107);
  late Color solidYellowColor = yellowColor.withOpacity(0.8);
  late Color primaryYellowColor = yellowColor.withOpacity(0.4);
  late Color secondaryYellowColor = yellowColor.withOpacity(0.2);

  Color orangeColor = const Color(0xfffd7e14);
  late Color solidOrangeColor = orangeColor.withOpacity(0.8);
  late Color primaryOrangeColor = orangeColor.withOpacity(0.4);
  late Color secondaryOrangeColor = orangeColor.withOpacity(0.2);

  Color greyColor = const Color(0xff30444F);
  late Color solidGreyColor = greyColor.withOpacity(0.8);
  late Color primaryGreyColor = greyColor.withOpacity(0.4);
  late Color secondaryGreyColor = greyColor.withOpacity(0.2);

  Color solidPurpleColor = const Color(0xff6f42c1);

  Color solidMarunColor = const Color(0xff87194C);
  Color solidNavyBlueColor = const Color(0xff1D1987);
  Color solidOliveColor = const Color(0xff838719);

  // Factory constructor to return the singleton instance
  //factory ColorSchema() => _instance;
  factory ColorSchema({Brightness? brightness}) {
    _instance.brightness = brightness;
    return _instance;
  }

  // Private constructor
  ColorSchema._();

  // Singleton instance
  static final ColorSchema _instance = ColorSchema._();

  // Deserialize from JSON
  factory ColorSchema.fromJson(Map<String, dynamic> json) {
    T parseColor<T>(dynamic value, T defaultValue) {
      if (value == null) return defaultValue;
      return Color(int.tryParse(value)!) as T;
    }

    return ColorSchema()
      ..primaryColor900 = parseColor(
        json['primaryColor900'],
        const Color(0xFF004021),
      )
      ..primaryColor800 = parseColor(
        json['primaryColor800'],
        const Color(0xFF00542B),
      )
      ..primaryColor700 = parseColor(
        json['primaryColor700'],
        const Color(0xFF006D38),
      )
      ..primaryColor600 = parseColor(
        json['primaryColor600'],
        const Color(0xFF008B48),
      )
      /*..primaryColor500 = parseColor(
        json['primaryColor500'],
        const Color(0xFF00994F),
      )*/
      ..primaryColor400 = parseColor(
        json['primaryColor400'],
        const Color(0xFF33AD72),
      )
      ..primaryColor300 = parseColor(
        json['primaryColor300'],
        const Color(0xFF54BB89),
      )
      ..primaryColor200 = parseColor(
        json['primaryColor200'],
        const Color(0xFF8AD0AE),
      )
      ..primaryColor100 = parseColor(
        json['primaryColor100'],
        const Color(0xFFB0DFC8),
      )
      ..primaryColor50 = parseColor(
        json['primaryColor50'],
        const Color(0xFFE6F5ED),
      )
      ..secondaryColor900 = parseColor(
        json['secondaryColor900'],
        const Color(0xFF141D21),
      )
      ..secondaryColor800 = parseColor(
        json['secondaryColor800'],
        const Color(0xFF1A252B),
      )
      ..secondaryColor700 = parseColor(
        json['secondaryColor700'],
        const Color(0xFF223038),
      )
      ..secondaryColor600 = parseColor(
        json['secondaryColor600'],
        const Color(0xFF2C3E48),
      )
      ..secondaryColor500 = parseColor(
        json['secondaryColor500'],
        const Color(0xFF30444F),
      )
      ..secondaryColor400 = parseColor(
        json['secondaryColor400'],
        const Color(0xFF596972),
      )
      ..secondaryColor300 = parseColor(
        json['secondaryColor300'],
        const Color(0xFF748289),
      )
      ..secondaryColor200 = parseColor(
        json['secondaryColor200'],
        const Color(0xFFA0A9AE),
      )
      ..secondaryColor100 = parseColor(
        json['secondaryColor100'],
        const Color(0xFFBFC5C8),
      )
      ..secondaryColor50 = parseColor(
        json['secondaryColor50'],
        const Color(0xFFEAECED),
      )

      // poskeeper colorschema
      ..primaryBackgroundColor = parseColor(
        json['primaryBackgroundColor'],
        const Color(0xFFffffff),
      )
      ..colorTwo = parseColor(
        json['colorTwo'],
        const Color(0xff2abba7),
      )
      ..primaryBaseColor = parseColor(
        json['primaryBaseColor'],
        const Color(0xFFfbbd05),
      )
      ..primaryLiteColor = parseColor(
        json['primaryLiteColor'],
        const Color(0xfffacf61),
      )
      ..tertiaryBaseColor = parseColor(
        json['tertiaryBaseColor'],
        const Color(0xFF34a853),
      )
      ..dangerBaseColor = parseColor(
        json['dangerBaseColor'],
        Colors.red,
      )
      ..dangerLiteColor = parseColor(
        json['dangerLiteColor'],
        Colors.red.withOpacity(.4),
      )
      ..successfulBaseColor = parseColor(
        json['successfulBaseColor'],
        Colors.green,
      )
      ..formClearIconColor = parseColor(
        json['formClearIconColor'],
        const Color(0xfffc1919),
      )
      ..formLabelColor = parseColor(
        json['formLabelColor'],
        const Color(0xFF716D64),
      )
      ..formExampleColor = parseColor(
        json['formExampleColor'],
        const Color(0xFF5A5750),
      )
      ..formErrorMsgColor = parseColor(
        json['formErrorMsgColor'],
        const Color(0xFFB2D4FF),
      )
      ..formBaseHintTextColor = parseColor(
        json['formBaseHintTextColor'],
        const Color(0xFF66A9FF),
      )
      ..formBaseBorderColor = parseColor(
        json['formBaseBorderColor'],
        const Color(0xFF7FB7FF),
      )
      ..formCursorColor = parseColor(
        json['formCursorColor'],
        const Color(0xff000000),
      )
      ..evenListColor = parseColor(
        json['evenListColor'],
        Colors.white,
      )
      ..oddListColor = parseColor(
        json['oddListColor'],
        const Color(0xFFeeeeee),
      )
      ..iconColor = parseColor(
        json['iconColor'],
        const Color(0xFFd8c8c3),
      )
      ..iconBackgroundColor = parseColor(
        json['iconBackgroundColor'],
        const Color(0xfff0e5e2),
      )
      ..moduleHeaderColor = parseColor(
        json['moduleHeaderColor'],
        const Color(0xFFf5edeb),
      )
      ..moduleBodyColor = parseColor(
        json['moduleBodyColor'],
        const Color(0xFFfffbff),
      )
      ..moduleFooterColor = parseColor(
        json['moduleFooterColor'],
        const Color(0xfff6f1f6),
      )
      ..borderColor = parseColor(
        json['borderColor'],
        const Color(0xFFece2d9),
      )
      ..primaryTextColor = parseColor(
        json['primaryTextColor'],
        const Color(0xFF4d4538),
      )
      ..secondaryTextColor = parseColor(
        json['secondaryTextColor'],
        const Color(0xFF5f5b58),
      )
      ..textFieldColor = parseColor(
        json['textFieldColor'],
        const Color(0xFFfffbff),
      )
      ..selectedColor = parseColor(
        json['selectedColor'],
        const Color(0xFFF7DFBB),
      )

      //
      ..primaryColor = parseColor(
        json['primaryColor'],
        const Color(0xFF004021),
      )
      ..secondaryColor = parseColor(
        json['secondaryColor'],
        const Color(0xFF141D21),
      )
      ..primaryTextColor = parseColor(
        json['primaryTextColor'],
        Colors.blue.shade900,
      )
      ..secondaryTextColor = parseColor(
        json['secondaryTextColor'],
        Colors.grey,
      )
      ..backgroundColor = parseColor(
        json['backgroundColor'],
        Colors.white,
      )
      ..textColorH6 = parseColor(
        json['textColorH6'],
        Colors.black,
      )
      ..successButtonBorderColor = parseColor(
        json['successButtonBorderColor'],
        const Color(0xff157347),
      )
      ..infoButtonFillColor = parseColor(
        json['infoButtonFillColor'],
        const Color(0xff31D2F2).withOpacity(.6),
      )
      ..removeButtonFillColor = parseColor(
        json['removeButtonFillColor'],
        const Color(0xffBB2D3B).withOpacity(.6),
      )
      ..editButtonFillColor = parseColor(
        json['editButtonFillColor'],
        const Color(0xff0b64ce).withOpacity(.6),
      )
      ..infoButtonIconColor = parseColor(
        json['editButtonTextColor'],
        const Color(0xff000000),
      )
      ..removeButtonIconColor = parseColor(
        json['editButtonTextColor'],
        const Color(0xffffffff),
      )
      ..editButtonIconColor = parseColor(
        json['editButtonTextColor'],
        const Color(0xffffffff),
      )
      ..buttonColor = parseColor(
        json['buttonColor'],
        const Color(0xFFC98A69),
      )
      ..solidBlueColor = parseColor(
        json['solidBlueColor'],
        const Color(0xff1E90FF),
      )
      ..solidGreenColor = parseColor(
        json['solidGreenColor'],
        const Color(0xff004D40),
      )
      ..solidRedColor = parseColor(
        json['solidRedColor'],
        const Color(0xffDC3545),
      )
      ..solidGreyColor = parseColor(
        json['solidGreyColor'],
        const Color(0xff5D6D7E),
      )
      ..solidPurpleColor = parseColor(
        json['solidPurpleColor'],
        const Color(0xff6D28D9),
      )
      ..solidYellowColor = parseColor(
        json['solidYellowColor'],
        const Color(0xffFFC107),
      );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'primaryColor900': primaryColor900.value.toString(),
      'primaryColor800': primaryColor800.value.toString(),
      'primaryColor700': primaryColor700.value.toString(),
      'primaryColor600': primaryColor600.value.toString(),
      'primaryColor500': primaryColor500.value.toString(),
      'primaryColor400': primaryColor400.value.toString(),
      'primaryColor300': primaryColor300.value.toString(),
      'primaryColor200': primaryColor200.value.toString(),
      'primaryColor100': primaryColor100.value.toString(),
      'primaryColor50': primaryColor50.value.toString(),
      'secondaryColor900': secondaryColor900.value.toString(),
      'secondaryColor800': secondaryColor800.value.toString(),
      'secondaryColor700': secondaryColor700.value.toString(),
      'secondaryColor600': secondaryColor600.value.toString(),
      'secondaryColor500': secondaryColor500.value.toString(),
      'secondaryColor400': secondaryColor400.value.toString(),
      'secondaryColor300': secondaryColor300.value.toString(),
      'secondaryColor200': secondaryColor200.value.toString(),
      'secondaryColor100': secondaryColor100.value.toString(),
      'secondaryColor50': secondaryColor50.value.toString(),
      // poskeeper

      'colorTwo': colorTwo,

      'backgroundColor': backgroundColor,
      'primaryBackgroundColor': primaryBackgroundColor,
      'primaryBaseColor': primaryBaseColor,
      'primaryLiteColor': primaryLiteColor,

      'tertiaryBaseColor': tertiaryBaseColor,

      'successfulBaseColor': successfulBaseColor,
      'dangerBaseColor': dangerBaseColor,
      'dangerLiteColor': dangerLiteColor,

      'iconColor': iconColor,
      'iconBackgroundColor': iconBackgroundColor,
      'moduleHeaderColor': moduleHeaderColor,
      'moduleBodyColor': moduleBodyColor,
      'moduleFooterColor': moduleFooterColor,
      'borderColor': borderColor,
      'primaryTextColor': primaryTextColor,
      'secondaryTextColor': secondaryTextColor,
      'textFieldColor': textFieldColor,
      'selectedColor': selectedColor,

      'formLabelColor': formLabelColor,
      'formExampleColor': formExampleColor,
      'formErrorMsgColor': formErrorMsgColor,
      'formBaseHintTextColor': formBaseHintTextColor,
      'formBaseBorderColor': formBaseBorderColor,

      'formCursorColor': formCursorColor,

      'formClearIconColor': formClearIconColor,

      'evenListColor': evenListColor,
      'oddListColor': oddListColor,

      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,

      'textColorH6': textColorH6,

      'successButtonBorderColor': successButtonBorderColor,

      'infoButtonFillColor': infoButtonFillColor,

      'removeButtonFillColor': removeButtonFillColor,

      'editButtonFillColor': editButtonFillColor,

      'editButtonIconColor': editButtonIconColor,

      'infoButtonIconColor': infoButtonIconColor,
      'removeButtonIconColor': removeButtonIconColor,

      'buttonColor': buttonColor,

      'solidBlueColor': solidBlueColor,
      'solidGreenColor': solidGreenColor,

      'solidGreyColor': solidGreyColor,
      'solidPurpleColor': solidPurpleColor,
      'solidYellowColor': solidYellowColor,

      'solidRedColor': solidRedColor,
      'primaryRedColor': primaryRedColor,
      'secondaryRedColor': secondaryRedColor,
    };
  }
}

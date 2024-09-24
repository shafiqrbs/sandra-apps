import 'package:flutter/material.dart';

const lightColor = {
  'primary_color_900': '0xFF004021',
  'primary_color_800': '0xFF00542B',
  'primary_color_700': '0xFF006D38',
  'primary_color_600': '0xFF008B48',
  'primary_color_500': '0xFF00994F',
  'primary_color_400': '0xFF33AD72',
  'primary_color_300': '0xFF54BB89',
  'primary_color_200': '0xFF8AD0AE',
  'primary_color_100': '0xFFB0DFC8',
  'primary_color_50': '0xFFE6F5ED',
  'secondary_color_900': '0xFF141D21',
  'secondary_color_800': '0xFF1A252B',
  'secondary_color_700': '0xFF223038',
  'secondary_color_600': '0xFF2C3E48',
  'secondary_color_500': '0xFF30444F',
  'secondary_color_400': '0xFF596972',
  'secondary_color_300': '0xFF748289',
  'secondary_color_200': '0xFFA0A9AE',
  'secondary_color_100': '0xFFBFC5C8',
  'secondary_color_50': '0xFFEAECED',
  'solidBlackColor': '0xFF000000',
};

// dark Color
const darkColor = {
  'primary_color_900': '0xFF000000',
  'primary_color_800': '0xFF1A1A1A',
  'primary_color_700': '0xFF333333',
  'primary_color_600': '0xFF4D4D4D',
  'primary_color_500': '0xFF000000',
  'primary_color_400': '0xFF808080',
  'primary_color_300': '0xFF999999',
  'primary_color_200': '0xFFB3B3B3',
  'primary_color_100': '0xFFCCCCCC',
  'primary_color_50': '0xFF000000',
  'secondary_color_900': '0xFF141D21',
  'secondary_color_800': '0xFF1A252B',
  'secondary_color_700': '0xFF223038',
  'secondary_color_600': '0xFF2C3E48',
  'secondary_color_500': '0xFF30444F',
  'secondary_color_400': '0xFF596972',
  'secondary_color_300': '0xFF748289',
  'secondary_color_200': '0xFFA0A9AE',
  'secondary_color_100': '0xFFBFC5C8',
  'secondary_color_50': '0xFF000000',
  'solidBlackColor': '0xFFFFFFFF',
};

class ColorSchema {
  // Factory constructor to return the singleton instance
  factory ColorSchema() => _instance;

  // Private constructor
  ColorSchema._();

  // Singleton instance
  static final ColorSchema _instance = ColorSchema._();

  Color primaryColor = const Color(0xFF00994F);
  Color secondaryColor = const Color(0xFF30444F);

  // Primary color
  Color primaryColor900 = const Color(0xff004021);
  Color primaryColor800 = const Color(0xff00542B);
  Color primaryColor700 = const Color(0xff006D38);
  Color primaryColor600 = const Color(0xff008B48);
  Color primaryColor500 = const Color(0xff00994F);
  Color primaryColor400 = const Color(0xff33AD72);
  Color primaryColor300 = const Color(0xff54BB89);
  Color primaryColor200 = const Color(0xff8AD0AE);
  Color primaryColor100 = const Color(0xffB0DFC8);
  Color primaryColor50 = const Color(0xffE6F5ED);

  // Secondary color
  Color secondaryColor900 = const Color(0xff141D21);
  Color secondaryColor800 = const Color(0xff1A252B);
  Color secondaryColor700 = const Color(0xff223038);
  Color secondaryColor600 = const Color(0xff2C3E48);
  Color secondaryColor500 = const Color(0xff30444F);
  Color secondaryColor400 = const Color(0xff596972);
  Color secondaryColor300 = const Color(0xff748289);
  Color secondaryColor200 = const Color(0xffA0A9AE);
  Color secondaryColor100 = const Color(0xffBFC5C8);
  Color secondaryColor50 = const Color(0xffEAECED);

  Color blueColor = const Color(0xff0d6efd);
  late Color solidBlueColor = blueColor.withOpacity(0.8);
  late Color primaryBlueColor = blueColor.withOpacity(0.4);
  late Color secondaryBlueColor = blueColor.withOpacity(0.2);

  Color blackColor = const Color(0xff000000);
  late Color solidBlackColor = blackColor.withOpacity(0.8);
  late Color primaryBlackColor = blackColor.withOpacity(0.4);
  late Color secondaryBlackColor = blackColor.withOpacity(0.2);

  Color whiteColor = const Color(0xffffffff);
  late Color solidWhiteColor = whiteColor.withOpacity(0.8);
  late Color primaryWhiteColor = whiteColor.withOpacity(0.4);
  late Color secondaryWhiteColor = whiteColor.withOpacity(0.2);

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

  // Method to update the color schema
  factory ColorSchema.fromJson(Map<String, dynamic> json) {
    T parseColor<T>(
      dynamic value,
    ) {
      return Color(int.tryParse(value)!) as T;
    }

    return ColorSchema()
      ..primaryColor900 = parseColor(json['primary_color_900'])
      ..primaryColor800 = parseColor(json['primary_color_800'])
      ..primaryColor700 = parseColor(json['primary_color_700'])
      ..primaryColor600 = parseColor(json['primary_color_600'])
      ..primaryColor500 = parseColor(json['primary_color_500'])
      ..primaryColor400 = parseColor(json['primary_color_400'])
      ..primaryColor300 = parseColor(json['primary_color_300'])
      ..primaryColor200 = parseColor(json['primary_color_200'])
      ..primaryColor100 = parseColor(json['primary_color_100'])
      ..primaryColor50 = parseColor(json['primary_color_50'])
      ..secondaryColor900 = parseColor(json['secondary_color_900'])
      ..secondaryColor800 = parseColor(json['secondary_color_800'])
      ..secondaryColor700 = parseColor(json['secondary_color_700'])
      ..secondaryColor600 = parseColor(json['secondary_color_600'])
      ..secondaryColor500 = parseColor(json['secondary_color_500'])
      ..secondaryColor400 = parseColor(json['secondary_color_400'])
      ..secondaryColor300 = parseColor(json['secondary_color_300'])
      ..secondaryColor200 = parseColor(json['secondary_color_200'])
      ..secondaryColor100 = parseColor(json['secondary_color_100'])
      ..secondaryColor50 = parseColor(json['secondary_color_50'])
      ..solidBlackColor = parseColor(json['solidBlackColor']);
  }
}

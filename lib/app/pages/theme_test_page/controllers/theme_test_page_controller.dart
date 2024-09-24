import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';
  import '/app/core/base/base_controller.dart';
  
class ThemeTestPageController extends BaseController {
 @override
  Future<void> onInit() async {
    super.onInit();
  }


  Future<void> changeTheme() async {
   // Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    ColorSchema.fromJson(
      Get.isDarkMode ? darkColor : lightColor,
    );
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await Get.forceAppUpdate();

    print('Current Theme: ${Get.isDarkMode ? 'Dark' : 'Light'}');
    print('Primary Color: ${ColorSchema().primaryColor900}');
  }
}
  
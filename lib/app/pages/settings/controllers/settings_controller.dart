import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import '/app/core/base/base_controller.dart';

enum Buttons {
  purchase,
}

class SettingsController extends BaseController {
  final buttons = Rx<Buttons?>(null);
  final isPrinterAllowed = ValueNotifier(false);
  final isEnableDarkMode = ValueNotifier(false);

  @override
  Future<void> onInit() async {
    super.onInit();
    isPrinterAllowed.value = await prefs.getIsPrinterAllowed();
    isEnableDarkMode.value = await prefs.getIsEnableDarkMode();
  }

  Future<void> setIsPrinterAllowed(bool value) async {
    isPrinterAllowed.value = value;
    await prefs.setIsPrinterAllowed(
      isPrinterAllowed: value,
    );
  }

  Future<void> setIsEnableDarkMode(bool value) async {
    showSnackBar(
      type: SnackBarType.warning,
      title: appLocalization.upcomingFeature,
      message: appLocalization.comingSoon,
    );
    return;
    isEnableDarkMode.value = value;
    await prefs.setIsEnableDarkMode(
      isEnableDarkMode: value,
    );

    Get.changeTheme(
      Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
    );
    ColorSchema.fromJson(
      Get.isDarkMode ? lightColor : darkColor,
    );
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }
}

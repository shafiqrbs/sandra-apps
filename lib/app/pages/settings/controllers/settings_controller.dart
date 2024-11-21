import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import 'package:sandra/app/routes/app_pages.dart';

enum Buttons {
  purchase,
}

class SettingsController extends PrinterController {
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

  Future<void> showPrinterConnectModal() async {
    await Get.dialog(
      DialogPattern(
        title: appLocalization.printerSetup,
        subTitle: appLocalization.connectYourPrinter,
        child: PrinterConnectModalView(),
      ),
    );
  }

  Future<void> clearLicense() async {
    await prefs.setIsLicenseValid(
      isLicenseValid: false,
    );
    await prefs.setIsLogin(
      isLogin: false,
    );
    Get.offAllNamed(
      Routes.splash,
    );
  }

  Future<void> sendLogs() async {
    final result = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (result) {

    }
  }
}

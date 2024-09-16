import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';

enum Buttons {
  purchase,
}

class SettingsController extends BaseController {
  final buttons = Rx<Buttons?>(null);
  final isPrinterAllowed = ValueNotifier(false);
  var isDarkMode = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isPrinterAllowed.value = await prefs.getIsPrinterAllowed();
  }

  Future<void> setIsPrinterAllowed(bool value) async {
    isPrinterAllowed.value = value;
    await prefs.setIsPrinterAllowed(
      isPrinterAllowed: value,
    );
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }

  void changeTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}

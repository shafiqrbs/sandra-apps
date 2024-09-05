import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/pages/dashboard/controllers/dashboard_controller.dart';
import '/app/core/base/base_controller.dart';

enum Buttons {
  printPaperType,
  purchase,
}

class PrefsSettingsModalController extends BaseController {
  final buttons = Rx<Buttons?>(null);
  final isSalesOnline = ValueNotifier(false);
  final isPurchaseOnline = ValueNotifier(false);
  final isZeroSalesAllowed = ValueNotifier(false);
  final printerType = ''.obs;
  final selectedPurchase = ''.obs;
  final printerNewLine = 0.obs;
  final printNewLineController = TextEditingController();
  final printerTypeList = [
    const DropdownMenuItem(value: '80 mm', child: Text('80 mm')),
    const DropdownMenuItem(value: '58 mm', child: Text('58 mm')),
  ];
  final newLineList = List<DropdownMenuItem<int>>.generate(
    11,
    (index) => DropdownMenuItem(
      value: index,
      child: Text(index.toString()),
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    isSalesOnline.value = await prefs.getIsSalesOnline();
    isPurchaseOnline.value = await prefs.getIsPurchaseOnline();
    isZeroSalesAllowed.value = await prefs.getIsZeroSalesAllowed();
    printerType.value = await prefs.getPrintPaperType();
    printerNewLine.value = await prefs.getNumberOfPrinterNewLine();
    printNewLineController.text = printerNewLine.value.toString();
    selectedPurchase.value = await prefs.getPurchaseConfig();
  }

  Future<void> setSalesOnline(bool value) async {
    isSalesOnline.value = value;
    await prefs.setIsSalesOnline(
      isSalesOnline: value,
    );
    final dashboardController = Get.find<DashboardController>();
    dashboardController.isOnline.value = value;
  }

  Future<void> setPurchaseOnline(bool value) async {
    isPurchaseOnline.value = value;
    await prefs.setIsPurchaseOnline(
      isPurchaseOnline: value,
    );
  }

  Future<void> setZeroSalesAllowed(bool value) async {
    isZeroSalesAllowed.value = value;
    await prefs.setIsZeroSalesAllowed(
      isZeroAllowed: value,
    );
  }

  Future<void> setPrinterType(String? value) async {
    if (value != null) {
      printerType.value = value;
      await prefs.setPrintPaperType(
        value,
      );
    }
  }

  Future<void> setPrinterNewLine(int value) async {
    printerNewLine.value = value;
    printNewLineController.text = value.toString();
    await prefs.setNumberOfPrinterNewLine(
      value,
    );
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }

  Future<void> changePurchase(String? config) async {
    if (config != null) {
      selectedPurchase.value = config;
      await prefs.setPurchaseConfig(config);
    }
  }
}

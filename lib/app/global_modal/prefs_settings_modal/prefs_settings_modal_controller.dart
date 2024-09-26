import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/pages/inventory/purchase/create_purchase/controllers/create_purchase_controller.dart';
import 'package:sandra/app/pages/inventory/sales/create_sales/controllers/create_sales_controller.dart';
import '/app/pages/dashboard/controllers/dashboard_controller.dart';
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
  final isHasPrinter = ValueNotifier(false);
  final isSalesAutoApproved = ValueNotifier(false);
  final isPurchaseAutoApproved = ValueNotifier(false);
  final isTotalPurchase = ValueNotifier(false);
  final isShowBrandOnPurchase = ValueNotifier(false);
  final isShowBrandOnSales = ValueNotifier(false);
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
    isHasPrinter.value = await prefs.getHasPrinter();
    isSalesAutoApproved.value = await prefs.getIsSalesAutoApprove();
    isPurchaseAutoApproved.value = await prefs.getIsPurchaseAutoApprove();
    printerType.value = await prefs.getPrintPaperType();
    printerNewLine.value = await prefs.getNumberOfPrinterNewLine();
    printNewLineController.text = printerNewLine.value.toString();
    selectedPurchase.value = await prefs.getPurchaseConfig();
    isTotalPurchase.value = await prefs.getTotalPriceConfig();
    isShowBrandOnPurchase.value = await prefs.getIsShowBrandOnPurchase();
    isShowBrandOnSales.value = await prefs.getIsShowBrandOnSales();
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

  Future<void> setHasPrinter(bool value) async {
    isHasPrinter.value = value;
    await prefs.setHasPrinter(
      hasPrinter: value,
    );
  }

  Future<void> setSalesAutoApproved(bool value) async {
    isSalesAutoApproved.value = value;
    await prefs.setIsSalesAutoApprove(
      isSalesAutoApprove: value,
    );
  }

  Future<void> setPurchaseAutoApproved(bool value) async {
    isPurchaseAutoApproved.value = value;
    await prefs.setIsPurchaseAutoApprove(
      isPurchaseAutoApprove: value,
    );
  }

  Future<void> setShowBrandOnPurchase(bool value) async {
    isShowBrandOnPurchase.value = value;
    await prefs.setIsShowBrandOnPurchase(
      isShowBrandOnPurchase: value,
    );
    if (Get.isRegistered<CreatePurchaseController>()) {
      final purchaseController = Get.find<CreatePurchaseController>();
      purchaseController.isShowBrand.value = value;
    }
  }

  Future<void> setShowBrandOnSales(bool value) async {
    isShowBrandOnSales.value = value;
    await prefs.setIsShowBrandOnSales(
      isShowBrandOnSales: value,
    );

    if (Get.isRegistered<CreateSalesController>()) {
      final salesController = Get.find<CreateSalesController>();
      salesController.isShowBrand.value = value;
    }
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
    if (config != null &&
        config.isNotEmpty &&
        config != selectedPurchase.value) {
      if (Get.isRegistered<CreatePurchaseController>()) {
        final purchaseController = Get.find<CreatePurchaseController>();
        if (purchaseController.purchaseItemList.value.isNotEmpty) {
          final isConfirm = await confirmationModal(
            msg: appLocalization.areYouSure,
          );
          if (isConfirm) {
            purchaseController.purchaseItemList.value = [];
            purchaseController.calculateAllSubtotal();
            if (purchaseController.prePurchase != null) {
              purchaseController.prePurchase = null;
            }
          } else {
            return;
          }
        }
      }

      selectedPurchase.value = config;
      await prefs.setPurchaseConfig(config);
    }
  }

  Future<void> setTotalPurchase(bool value) async {
    isTotalPurchase.value = value;
    await prefs.setTotalPriceConfig(
      isTotalPrice: value,
    );
  }
}

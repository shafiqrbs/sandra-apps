import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';

class PrefsSettingsModalController extends BaseController {
  final isSalesOnline = false.obs;
  final isPurchaseOnline = false.obs;
  final isZeroSalesAllowed = false.obs;
  final printerType = ''.obs;
  final printerNewLine = 0.obs;
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
  }

  Future<void> setSalesOnline(bool value) async {
    isSalesOnline.value = value;
    await prefs.setIsSalesOnline(
      isSalesOnline: value,
    );
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

  Future<void> setPrinterType(String value) async {
    printerType.value = value;
    await prefs.setPrintPaperType(
      value,
    );
  }

  Future<void> setPrinterNewLine(int value) async {
    printerNewLine.value = value;
    await prefs.setNumberOfPrinterNewLine(
      value,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/sales.dart';
import 'package:sandra/app/entity/sales_item.dart';
import '/app/core/base/base_controller.dart';

class SalesReturnPageController extends BaseController {
  final sales = Rx<Sales?>(null);
  final originalSales = Rx<Sales?>(null);
  final paymentController = TextEditingController();
  final adjustmentController = TextEditingController();
  final remarkController = TextEditingController();
  final generatedList = <int, SalesItem>{};

  final totalReturnAmount = Rx<String?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['sales'] != null) {
        sales.value = args['sales'] as Sales;
        originalSales.value = sales.value;
        totalReturnAmount.value = '0';
        if (kDebugMode) {
          print('Sales: ${sales.value?.salesId}');
        }
      }
    }
  }

  Future<void> resetField() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      paymentController.clear();
      adjustmentController.clear();
      remarkController.clear();
      sales
        ..value = originalSales.value
        ..refresh();
    }
  }

  void save() {
    //services.postSales(salesList: salesList, mode: mode)
    final adjustment = double.tryParse(adjustmentController.text) ?? 0;
    final payment = double.tryParse(paymentController.text) ?? 0;
    final sum = adjustment + payment;
    final returning = double.tryParse(totalReturnAmount.value ?? '0') ?? 0;
    if (sum != returning) {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.thisAmountIsNotValid,
      );
      return;
    }


  }

  void addItem(SalesItem item) {
    generatedList.update(
      item.stockId!,
      (existingValue) {
        return item;
      },
      ifAbsent: () {
        return item;
      },
    );
    calculateReturnAmount();
  }

  void removeItem(int? elementId) {
    if (generatedList.containsKey(elementId)) {
      generatedList.remove(elementId);
    }
    calculateReturnAmount();
  }

  void calculateReturnAmount() {
    num total = 0;
    generatedList.forEach(
      (key, value) {
        total += value.subTotal ?? 0;
      },
    );
    totalReturnAmount.value = total.toString();
  }
}

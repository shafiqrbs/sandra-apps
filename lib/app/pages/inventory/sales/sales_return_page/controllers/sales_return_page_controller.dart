import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/entity/sales.dart';
import '/app/core/base/base_controller.dart';

class SalesReturnPageController extends BaseController {
  final sales = Rx<Sales?>(null);
  final originalSales = Rx<Sales?>(null);
  final paymentController = TextEditingController();
  final adjustmentController = TextEditingController();
  final remarkController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['sales'] != null) {
        sales.value = args['sales'] as Sales;
        originalSales.value = sales.value;
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

  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sandra/app/core/core_model/logged_user.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/sales.dart';
import 'package:sandra/app/entity/sales_item.dart';

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

  Future<void> save() async {
    //services.postSales(salesList: salesList, mode: mode)

    if (generatedList.isEmpty) {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.thisAmountIsNotValid,
      );
      return;
    }

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

    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );

    if (!confirmation) return;

    final data = {
      'sales_id': sales.value?.salesId,
      'created_by_id': LoggedUser().userId,
      'sub_total': double.tryParse(totalReturnAmount.value ?? '0'),
      'receive': payment,
      'adjustment': adjustment,
      'comment': remarkController.text,
      'items': jsonEncode(
        generatedList.values
            .map(
              (e) => {
                'sales_item_id': e.stockId,
                'sales_price': e.salesPrice,
                'quantity': e.quantity,
                'sub_total': e.subTotal,
              },
            )
            .toList(),
      ),
    };

    if (kDebugMode) {
      print('Data: $data');
    }

    bool? isSuccess;

    await dataFetcher(
      future: () async {
        isSuccess = await services.postSalesReturn(
          content: data,
        );
      },
    );

    if (isSuccess ?? false) {
      while (Get.currentRoute != Routes.dashboard) {
        Get.back();
      }
      Get.toNamed(Routes.salesReturnListPage);
      showSnackBar(
        message: appLocalization.success,
        type: SnackBarType.success,
      );
    } else {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.failedToSave,
      );
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

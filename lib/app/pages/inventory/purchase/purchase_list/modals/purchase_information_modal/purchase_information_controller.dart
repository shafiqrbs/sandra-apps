import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/base/base_controller.dart';
import 'package:getx_template/app/entity/purchase.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import '/app/routes/app_pages.dart';

class PurchaseInformationController extends BaseController {
  final String purchaseMode;
  final purchase = Rx<Purchase?>(null);

  PurchaseInformationController({
    required Purchase purchase,
    required this.purchaseMode,
  }) {
    this.purchase.value = purchase;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if (purchaseMode == 'online') {
      await getSalesItemList();
    }
  }

  Future<void> getSalesItemList() async {
    await dataFetcher(
      future: () async {
        final data = await services.getOnlinePurchaseDetails(
          id: purchase.value!.purchaseId!,
        );
        if (data != null) {
          purchase.value!.purchaseItem = data.purchaseItem;
          purchase.refresh();
          update();
          notifyChildrens();
          refresh();
        }
      },
    );
  }

  Future<void> salesPrint(BuildContext context) async {
    final isPrinted = await printSales(purchase.value!);
    if (isPrinted) {
      return;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogPattern(
            title: 'title',
            subTitle: 'subTitle',
            child: PrinterConnectModalView(),
          );
        },
      );
    }
  }

  Future<void> copyPurchase(Purchase purchase) async {
    if (purchaseMode == 'hold') {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tablePurchase,
        where: 'purchase_id = ?',
        whereArgs: [
          purchase.purchaseId,
        ],
      );
    }
  }

  void goToEditSales() {
    Get.toNamed(
      Routes.createSales,
      arguments: {
        'sales': purchase.value,
      },
    );
  }

  printSales(Purchase purchase) {}
}

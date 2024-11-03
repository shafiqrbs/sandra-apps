import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/pdf_views/sales_purchase_pdf_function.dart';
import '/app/core/abstract_controller/printer_controller.dart';
import '/app/core/utils/static_utility_function.dart';

import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/purchase.dart';
import '/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import '/app/routes/app_pages.dart';

class PurchaseInformationController extends PrinterController {
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
      await getPurchaseItemList();
    }
  }

  Future<void> getPurchaseItemList() async {
    await dataFetcher(
      future: () async {
        final data = await services.getOnlinePurchaseDetails(
          id: purchase.value!.purchaseId!,
        );
        if (data != null) {
          purchase.value = data;
          purchase.value!.purchaseItem = data.purchaseItem;
          purchase.refresh();
          update();
          notifyChildrens();
          refresh();
        }
      },
    );
  }

  Future<void> purchasePrint(BuildContext context) async {
    final isPrinted = await printPurchase(
      purchase.value!,
    );
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

  Future<void> copyPurchase() async {
    if (purchaseMode == 'hold') {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tablePurchase,
        where: 'purchase_id = ?',
        whereArgs: [
          purchase.value?.purchaseId,
        ],
      );
    }

    Get
      ..back()
      ..offNamed(
        Routes.createPurchase,
        arguments: {
          'purchase_item_list': purchase.value?.purchaseItem,
        },
      );
  }

  void goToEditPurchase() {
    Get.toNamed(
      Routes.createPurchase,
      arguments: {
        'purchase': purchase.value,
      },
    );
  }

  Future<void> deletePurchase({
    required Function? onDeleted,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );

    if (!confirmation) return;

    bool isDeleted = false;
    if (purchaseMode == 'online') {
      await dataFetcher(
        future: () async {
          isDeleted = await services.deletePurchase(
            id: purchase.value!.purchaseId!,
          );
        },
      );
    } else {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tablePurchase,
        where: 'purchase_id = ?',
        whereArgs: [purchase.value!.purchaseId],
      );
      isDeleted = true;
    }
    if (isDeleted) {
      onDeleted!();
    }
  }

  Future<void> createPurchaseDetailsPdf({
    required Purchase purchase,
  }) async {
    await generatePurchasePdf(purchase);
  }
}

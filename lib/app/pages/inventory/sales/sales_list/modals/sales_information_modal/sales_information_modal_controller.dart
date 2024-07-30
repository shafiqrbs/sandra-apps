import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/common_confirmation_modal.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import '/app/routes/app_pages.dart';

class SalesInformationModalController extends PrinterController {
  final String salesMode;
  Rx<Sales?> sales = Rx<Sales?>(null);

  SalesInformationModalController({
    required Sales sales,
    required this.salesMode,
  }) {
    this.sales.value = sales;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if (salesMode == 'online') {
      await getSalesItemList();
    }
  }

  Future<void> getSalesItemList() async {
    await dataFetcher(
      future: () async {
        final data = await services.getOnlineSalesDetails(
          id: sales.value!.salesId!,
        );
        if (data != null) {
          sales.value!.salesItem = data.salesItem;
          sales.refresh();
          update();
          notifyChildrens();
          refresh();
        }
      },
    );
  }

  Future<void> salesPrint(BuildContext context) async {
    final isPrinted = await printSales(sales.value!);
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

  Future<void> copySales(Sales sales) async {
    if (salesMode == 'hold') {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tableSale,
        where: 'sales_id = ?',
        whereArgs: [sales.salesId],
      );
    }
  }

  void goToEditSales() {
    Get
      ..back()
      ..offNamed(
        Routes.createSales,
        arguments: {
          'sales': sales.value,
        },
      );
  }

  Future<void> deleteSales({
    required Function? onDeleted,
  }) async {
    final confirmation = await showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return CommonConfirmationModal(
          title: 'do_you_want_to_delete_this_sales?'.tr,
        );
      },
    );

    if (confirmation) {
      print('delete sales');
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tableSale,
        where: 'sales_id = ?',
        whereArgs: [sales.value!.salesId],
      );
      onDeleted!();
    }
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/pdf_views/sales_purchase_pdf_function.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import '/app/routes/app_pages.dart';

class SalesInformationWithoutInvoiceModalController extends PrinterController {
  final String salesMode;
  Rx<Sales?> sales = Rx<Sales?>(null);

  SalesInformationWithoutInvoiceModalController({
    required this.salesMode,
  });

  @override
  Future<void> onInit() async {
    super.onInit();

  }

  Future<void> getSalesItemList() async {
    await dataFetcher(
      future: () async {
        final data = await services.getOnlineSalesDetails(
          id: sales.value!.salesId!,
        );
        if (data != null) {
          sales
            ..value = data
            ..refresh();
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
            title: 'PrinterSetup',
            subTitle: 'subTitle',
            child: PrinterConnectModalView(),
          );
        },
      );
    }
  }

  Future<void> copySales() async {
    if (salesMode == 'hold') {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tableSale,
        where: 'sales_id = ?',
        whereArgs: [sales.value?.salesId],
      );
    }

    Get
      ..back()
      ..offNamed(
        Routes.createSales,
        arguments: {
          'sales_item_list': sales.value?.salesItem,
        },
      );
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
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );

    if (confirmation) {
      bool isDeleted = false;
      if (salesMode == 'online') {
        await dataFetcher(
          future: () async {
            isDeleted = await services.deleteSales(
              id: sales.value!.salesId!,
            );
          },
        );
      } else {
        await dbHelper.deleteAllWhr(
          tbl: dbTables.tableSale,
          where: 'sales_id = ?',
          whereArgs: [sales.value!.salesId],
        );
        isDeleted = true;
      }
      if (isDeleted) {
        onDeleted!();
      }
    }
  }

  Future<void> createSalesDetailsPdf({
    required Sales sales,
  }) async {
    await generateSalesPdf(sales);
  }

  void returnSales() {
    Get.offNamed(
      Routes.salesReturnPage,
      arguments: {
        'sales': sales.value,
      },
    );
  }
}

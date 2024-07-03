import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terminalbd/core/abstract_controller/printer_controller.dart';
import 'package:terminalbd/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import 'package:terminalbd/global_modal/printer_connect_modal_view/printer_connect_modal_view_controller.dart';
import 'package:terminalbd/global_widget/dialog_pattern.dart';
import 'package:terminalbd/model/sales.dart';
import 'package:terminalbd/pages/domain/landing_screen/landing_screen.dart';
import 'package:terminalbd/pages/inventory/pos_screen/pos_controller.dart';

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
    await newServices.fetchOnlineData(
      () async {
        final data = await newServices.getOnlineSalesDetails(
          shouldShowLoader: true,
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

    if (Get.isRegistered<PrinterConnectModalViewController>()) {
      Get.delete<PrinterConnectModalViewController>();
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
    if (salesMode == 'hold' ) {
      await dbHelper.deleteAllWhr(
        tbl: tableSale,
        where: 'sales_id = ?',
        whereArgs: [sales.salesId],
      );
    }

    Get
      ..offAll(LandingScreen())
      ..put(PosController());
    final posController = Get.find<PosController>();
    posController.salesItemList.clear();
    posController.salesItemList.addAll(sales.salesItem!);
    posController.calculateAllSubtotal();
  }
}

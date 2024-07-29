import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/entity/sales.dart';
import '/app/pages/inventory/sales/create_sales/controllers/create_sales_controller.dart';
import '/app/routes/app_pages.dart';

class OrderProcessConfirmationController extends PrinterController {
  final Sales sales;
  final bool isEdit;
  OrderProcessConfirmationController({
    required this.sales,
    required this.isEdit,
  });

  @override
  Future<void> onInit() async {
    await getBluetoothList();
    return super.onInit();
  }

  Future<void> salesPrint() async {
    if (kDebugMode) {
      print('print');
      print('sales: ${sales.toJson()}');
    }

    if (!connected.value) {
      toast('please_connect_printer'.tr);
      return;
    }

    final isPrinted = await printSales(sales);
    if (isPrinted) {
      await saveSales();

      toast('print_success'.tr);
    } else {
      toast('print_failed'.tr);
    }
  }

  Future<void> saveSales() async {
    if (isEdit) {
      await _updateSales();
    } else {
      await _insertSales();
    }
  }

  Future<void> _updateSales() async {
    final isSalesOnline = sales.isOnline == 1;

    if (isSalesOnline) {
      await _onlineUpdate();
    } else {
      await _localUpdate();
    }
  }

  Future<void> _insertSales() async {
    final isOnline = await prefs.getIsSalesOnline();

    if (isOnline) {
      await _onlineInsert();
    } else {
      await _localInsert();
    }
  }

  Future<void> _localInsert() async {
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tableSale,
      dataList: [sales.toJson()],
    );
    _navigateToLanding();
  }

  Future<void> _localUpdate() async {
    await dbHelper.updateWhere(
      tbl: dbTables.tableSale,
      data: sales.toJson(),
      where: 'sales_id = ?',
      whereArgs: [sales.salesId],
    );
    _navigateToLanding();
  }

  void _navigateToLanding() {
    Get
      ..back()
      ..back();
    if (Get.isRegistered<CreateSalesController>()) {
      final createSalesController = Get.find<CreateSalesController>();
      createSalesController.salesItemList.value = [];
      createSalesController.calculateAllSubtotal();
    }
  }

  void _showUpdateError() {
    // Display an error message to the user
    print('Failed to update sales online.');
  }

  Future<void> scanBluetooth() async {
    await getBluetoothList();
  }

  Future<void> _onlineUpdate() async {
    bool? isUpdated;
    await dataFetcher(
      future: () async {
        isUpdated = await services.updateSales(
          salesList: [sales],
        );
      },
    );
    if (isUpdated ?? false) {
      _navigateToLanding();
    } else {
      _showUpdateError();
    }
  }

  Future<void> _onlineInsert() async {
    bool? isInserted;
    await dataFetcher(
      future: () async {
        isInserted = await services.postSales(
          salesList: [sales],
          mode: 'online',
        );
      },
    );
    if (isInserted ?? false) {
      _navigateToLanding();
    } else {
      await _localInsert();
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/entity/purchase.dart';
import '/app/routes/app_pages.dart';

class PurchaseConfirmController extends PrinterController {
  final Purchase purchase;
  final bool isEdit;
  PurchaseConfirmController({
    required this.purchase,
    required this.isEdit,
  });

  @override
  Future<void> onInit() async {
    await getBluetoothList();
    return super.onInit();
  }

  Future<void> saveHold() async {
    purchase.isHold = 1;
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tablePurchase,
      dataList: [
        purchase.toJson(),
      ],
    );
    Get.offAllNamed(
      Routes.dashboard,
    );
  }

  Future<void> purchasePrint() async {
    if (kDebugMode) {
      print('print');
      print('purchase : ${purchase.toJson()}');
    }

    if (!connected.value) {
      toast('please_connect_printer'.tr);
      return;
    }

    final isPrinted = await printPurchase(
      purchase,
    );
    if (isPrinted) {
      await savePurchase();

      toast('print_success'.tr);
    } else {
      toast('print_failed'.tr);
    }
  }

  Future<void> savePurchase() async {
    if (isEdit) {
      await _updatePurchase();
    } else {
      await _insertPurchase();
    }
  }

  Future<void> _updatePurchase() async {
    final isSalesOnline = purchase.isOnline == 1;

    if (isSalesOnline) {
      await dataFetcher(
        future: () async {
          final isUpdated = await services.updateSales(
            salesList: [
              purchase,
            ],
          );
          if (isUpdated) {
            _navigateToLanding();
          } else {
            _showUpdateError();
          }
        },
      );
    } else {
      await _localUpdate();
    }
  }

  Future<void> _insertPurchase() async {
    final isOnline = await prefs.getIsSalesOnline();

    if (isOnline) {
      await dataFetcher(
        future: () async {
          final isSynced = await services.postPurchase(
            purchaseList: [purchase],
            mode: 'online',
          );
          if (isSynced) {
            _navigateToLanding();
          } else {
            await _localInsert();
          }
        },
      );
    } else {
      await _localInsert();
    }
  }

  Future<void> _localInsert() async {
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tablePurchase,
      dataList: [purchase.toJson()],
    );
    _navigateToLanding();
  }

  Future<void> _localUpdate() async {
    await dbHelper.updateWhere(
      tbl: dbTables.tablePurchase,
      data: purchase.toJson(),
      where: 'purchase_id = ?',
      whereArgs: [
        purchase.purchaseId,
      ],
    );
    _navigateToLanding();
  }

  void _navigateToLanding() {
    Get.offAllNamed(
      Routes.dashboard,
    );
  }

  void _showUpdateError() {
    // Display an error message to the user
    print('Failed to update sales online.');
  }

  Future<void> scanBluetooth() async {
    await getBluetoothList();
  }

  printPurchase(Purchase purchase) {}
}

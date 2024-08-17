import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/entity/purchase.dart';
import '/app/pages/inventory/purchase/create_purchase/controllers/create_purchase_controller.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/entity/purchase.dart';

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

  Future<void> purchasePrint() async {
    if (kDebugMode) {
      print('purchasePrint invoked');
      print('purchase: ${purchase.toJson()}');
    }

    if (!connected.value) {
      toast('please_connect_printer'.tr);
      return;
    }

    // Attempt to save purchase
    try {
      await savePurchase().then(
        (value) async {
          final isPrinted = await printPurchase(purchase);

          if (isPrinted) {
            toast('print_success'.tr);
          } else {
            toast('print_failed'.tr);
          }
        },
      );
    } catch (e) {
      // Handle any errors that occur during the save operation
      toast('save_failed'.tr);
      print('Error saving purchase: $e');
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
    final isPurchaseOnline = purchase.isOnline == 1;

    if (isPurchaseOnline) {
      await _onlineUpdate();
    } else {
      await _localUpdate();
    }
  }

  Future<void> _insertPurchase() async {
    final isOnline = await prefs.getIsPurchaseOnline();

    if (isOnline) {
      await _onlineInsert();
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
    final isOnline = await prefs.getIsPurchaseOnline();
    if (isOnline) {
      toast(
        'Online Purchase Failed Save Locally',
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
    _navigateToLanding();
  }

  Future<void> _localUpdate() async {
    await dbHelper.updateWhere(
      tbl: dbTables.tablePurchase,
      data: purchase.toJson(),
      where: 'purchase_id = ?',
      whereArgs: [purchase.purchaseId],
    );
    _navigateToLanding();
  }

  void _navigateToLanding() {
    logger.i('saving');
    Get
      ..back()
      ..back();
    if (Get.isRegistered<CreatePurchaseController>()) {
      final createPurchaseController = Get.find<CreatePurchaseController>();
      createPurchaseController.purchaseItemList.value = [];
      createPurchaseController.calculateAllSubtotal();
    }
  }

  void _showUpdateError() {
    // Display an error message to the user
    print('Failed to update purchase online.');
  }

  Future<void> scanBluetooth() async {
    await getBluetoothList();
  }

  Future<void> _onlineUpdate() async {
    bool? isUpdated;
    await dataFetcher(
      future: () async {
        isUpdated = await services.updatePurchase(
          purchaseList: [purchase],
        );
      },
      shouldShowErrorModal: false,
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
        isInserted = await services.postPurchase(
          purchaseList: [purchase],
          mode: 'online',
        );
      },
      shouldShowErrorModal: false,
    );

    if (isInserted ?? false) {
      _navigateToLanding();
    } else {
      await _localInsert();
    }
  }
}

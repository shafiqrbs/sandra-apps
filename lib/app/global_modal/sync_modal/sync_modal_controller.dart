import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/pages/inventory/purchase/purchase_list/controllers/purchase_list_controller.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/entity/sales.dart';
import '/app/pages/inventory/sales/sales_list/controllers/sales_list_controller.dart';
import '/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';
import '/app/core/core_model/setup.dart';

enum SyncType {
  export,
  import,
}

class SyncModalController extends BaseController {
  final selectedSyncType = SyncType.export.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeType(SyncType type) {
    selectedSyncType.value = type;
  }

  Future<void> syncCustomer() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    await dataFetcher(
      future: () async {
        await 5.delay();
        //await services.syncCustomer();
      },
    );
  }

  Future<void> sync() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    final license = await prefs.getLicenseKey();
    final activeKey = await prefs.getActiveKey();
    await dataFetcher(
      future: () async {
        final value = await services.submitLicense(
          license: license,
          activeKey: activeKey,
        );
        if (value != null) {
          final isInserted = await insertSplashDataToDb(
            splashData: value,
          );

          if (isInserted) {
            toast(appLocalization.licenseAndKeyValidatedSuccessfully);
          }
        }
      },
    );
  }

  Future<bool> insertSplashDataToDb({
    required Map<String, dynamic> splashData,
  }) async {
    if (splashData.isNotEmpty) {
      if (splashData['setup'] != null && splashData['setup'].isNotEmpty) {
        SetUp.fromJson(splashData['setup'][0]);
      } else {
        await prefs.setIsLicenseValid(isLicenseValid: false);
        toast(appLocalization.pleaseTryAgain);
        return false;
      }
      final keys = splashData.keys.toList();

      //async loop
      await Future.forEach<String>(
        keys,
        (key) async {
          final value = splashData[key];
          if (value != null && value is List && value.isNotEmpty) {
            await dbHelper.insertList(
              deleteBeforeInsert: true,
              tableName: key,
              dataList: value.map((e) => Map<String, dynamic>.from(e)).toList(),
            );
          }
        },
      );
    } else {
      await prefs.setIsLicenseValid(isLicenseValid: false);
      toast(appLocalization.pleaseTryAgain);
      return false;
    }

    await prefs.setIsLicenseValid(isLicenseValid: true);
    toast(appLocalization.licenseAndKeyValidatedSuccessfully);
    return true;
  }

  Future<void> exportSales() async {
    final salesList = await dbHelper.getAllWhr(
      tbl: dbTables.tableSale,
      where: 'is_hold is null or is_hold == 0',
      whereArgs: [],
    );

    if (salesList.isEmpty) {
      showSnackBar(
        message: appLocalization.noDataFound,
        title: appLocalization.error,
      );
      return;
    }
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    bool? isSalesSynced;

    await dataFetcher(
      future: () async {
        isSalesSynced = await services.postSales(
          salesList: salesList,
          mode: 'offline',
        );
      },
    );

    if (isSalesSynced ?? false) {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tableSale,
        where: 'is_hold is null or is_hold == 0',
        whereArgs: [],
      );
      if (Get.isRegistered<SalesListController>()) {
        final salesListController = Get.find<SalesListController>();

        final selectedIndex = salesListController.selectedIndex.value;
        if (selectedIndex == 0) {
          salesListController.selectedIndex.value = 100;
          await salesListController.changeTab(selectedIndex);
        }
      }
    }
  }

  Future<void> exportPurchase() async {
    final purchaseList = await dbHelper.getAllWhr(
      tbl: dbTables.tablePurchase,
      where: 'is_hold is null or is_hold == 0',
      whereArgs: [],
    );

    if (purchaseList.isEmpty) {
      showSnackBar(
        message: appLocalization.noDataFound,
        title: appLocalization.error,
      );
      return;
    }

    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    bool? isPurchaseSynced;

    await dataFetcher(
      future: () async {
        isPurchaseSynced = await services.postPurchase(
          purchaseList: purchaseList,
          mode: 'offline',
        );
      },
    );

    if (isPurchaseSynced ?? false) {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tablePurchase,
        where: 'is_hold is null or is_hold == 0',
        whereArgs: [],
      );

      if (Get.isRegistered<PurchaseListController>()) {
        final purchaseListController = Get.find<PurchaseListController>();

        final selectedIndex = purchaseListController.selectedIndex.value;
        if (selectedIndex == 1) {
          purchaseListController.selectedIndex.value = 100;
          await purchaseListController.changeTab(selectedIndex);
        }
      }
    } else {
      toast(
        appLocalization.syncFailed,
      );
    }
  }

  void exportExpense() {}

  Future<void> generateSales() async {
    final singleSales = await dbHelper
        .getAll(
          tbl: dbTables.tableSale,
        )
        .then(
          (value) => Sales.fromJson(
            value.first,
          ),
        );

    final salesList = List.generate(
      1000,
      (index) => singleSales,
    );

    await dbHelper.insertList(
      tableName: dbTables.tableSale,
      dataList: salesList.map((e) => e.toJson()).toList(),
      deleteBeforeInsert: false,
    );
    await exportPurchase();
  }

  Future<void> importStockItem() async {
    final needExportData = await needExport();
    if (!needExportData) {
      return;
    }

    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    await dataFetcher(
      future: () async {
        final stockItemList = await services.getStockItems();
        if (stockItemList?.isNotEmpty ?? false) {
          await dbHelper.insertList(
            tableName: dbTables.tableStocks,
            dataList: stockItemList!,
            deleteBeforeInsert: true,
          );
          showSnackBar(message: appLocalization.success);
        }
      },
    );
  }

  Future<void> importMasterData() async {
    final needExportData = await needExport();
    if (!needExportData) {
      return;
    }

    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    try {
      await dataFetcher(
        future: () async {
          final masterData = await services.getMasterData();
          if (masterData?.isNotEmpty ?? false) {
            if (masterData!['setup'] != null &&
                masterData['setup'].isNotEmpty) {
              SetUp.fromJson(masterData['setup'][0]);
            }
            final keys = masterData.keys.toList();
            await Future.forEach<String>(
              keys,
              (key) async {
                final value = masterData[key];
                if (value != null && value is List) {
                  if (value.isEmpty) {
                    await dbHelper.deleteAll(tbl: key);
                    return;
                  }
                  await dbHelper.insertList(
                    deleteBeforeInsert: true,
                    tableName: key,
                    dataList:
                        value.map((e) => Map<String, dynamic>.from(e)).toList(),
                  );
                }
              },
            );
            showSnackBar(message: appLocalization.success);
          }
        },
      );
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      showSnackBar(message: appLocalization.failed);
    }
  }

  Future<bool> needExport() async {
    final salesCount = await dbHelper.getItemCount(
      tableName: dbTables.tableSale,
    );

    if (salesCount > 0) {
      showSnackBar(message: appLocalization.exportYourSales);
      return false;
    }

    final purchaseCount = await dbHelper.getItemCount(
      tableName: dbTables.tablePurchase,
    );

    if (purchaseCount > 0) {
      showSnackBar(message: appLocalization.exportYourPurchase);
      return false;
    }

    return true;
  }
}

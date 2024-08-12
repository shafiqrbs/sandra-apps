import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/entity/sales.dart';
import 'package:sandra/app/pages/inventory/sales/sales_list/controllers/sales_list_controller.dart';
import 'package:sandra/app/routes/app_pages.dart';
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
        toast('please_try_again'.tr);
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
      toast('please_try_again'.tr);
      return false;
    }

    await prefs.setIsLicenseValid(isLicenseValid: true);
    toast('license_and_key_validated_successfully'.tr);
    return true;
  }

  Future<void> exportSales() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }
    final salesList = await dbHelper.getAllWhr(
      tbl: dbTables.tableSale,
      where: 'is_hold is null or is_hold == 0',
      whereArgs: [],
    );

    if (salesList.isEmpty) {
      toast(appLocalization.noDataFound);
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
      await dbHelper.deleteAll(
        tbl: dbTables.tableSale,
      );
      if (Get.isRegistered<SalesListController>()) {
        final salesListController = Get.find<SalesListController>();

        final selectedIndex = salesListController.selectedIndex.value;
        if (selectedIndex == 0) {
          salesListController.selectedIndex.value = 100;
          await salesListController.changeIndex(selectedIndex);
        }
      }
    }
  }

  Future<void> exportPurchase() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }
    final purchaseList = await dbHelper.getAll(
      tbl: dbTables.tablePurchase,
    );

    if (purchaseList.isEmpty) {
      toast(appLocalization.noDataFound);
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
      await dbHelper.deleteAll(
        tbl: dbTables.tablePurchase,
      );
      Get.offAllNamed(Routes.splash);
    } else {
      toast(appLocalization.syncFailed);
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
}

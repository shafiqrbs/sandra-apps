import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/pages/inventory/purchase/create_purchase/controllers/create_purchase_controller.dart';
import 'package:sandra/app/pages/inventory/sales/create_sales/controllers/create_sales_controller.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';

import '/app/pages/dashboard/controllers/dashboard_controller.dart';

enum Buttons {
  printPaperType,
  purchase,
}

class PrefsSettingsModalController extends BaseController {
  final buttons = Rx<Buttons?>(null);
  final isSalesOnline = ValueNotifier(false);
  final isTableEnabled = ValueNotifier(false);
  final isAllPrintEnabled = ValueNotifier(false);
  final isPurchaseOnline = ValueNotifier(false);
  final isZeroSalesAllowed = ValueNotifier(false);
  final isHasPrinter = ValueNotifier(false);
  final isSalesAutoApproved = ValueNotifier(false);
  final isPurchaseAutoApproved = ValueNotifier(false);
  final isShowBrandOnPurchase = ValueNotifier(false);
  final isShowBrandOnSales = ValueNotifier(false);
  final selectedPurchase = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isTableEnabled.value = await prefs.getIsisTableEnabled();
    isAllPrintEnabled.value = await prefs.getIsAllPrintEnabled();
    isSalesOnline.value = await prefs.getIsSalesOnline();
    isPurchaseOnline.value = await prefs.getIsPurchaseOnline();
    isZeroSalesAllowed.value = await prefs.getIsZeroSalesAllowed();
    isHasPrinter.value = await prefs.getHasPrinter();
    isSalesAutoApproved.value = await prefs.getIsSalesAutoApprove();
    isPurchaseAutoApproved.value = await prefs.getIsPurchaseAutoApprove();

    selectedPurchase.value = await prefs.getPurchaseConfig();
    isShowBrandOnPurchase.value = await prefs.getIsShowBrandOnPurchase();
    isShowBrandOnSales.value = await prefs.getIsShowBrandOnSales();
  }

  Future<void> setTableEnable(bool value) async {
    isTableEnabled.value = value;
    await prefs.setIsTableEnabled(
      isTableEnabled: value,
    );
    if (Get.isRegistered<RestaurantHomeController>()) {
      final restaurantHomeController = Get.find<RestaurantHomeController>();
      restaurantHomeController.isTableEnabled.value = value;
    }
  }

  Future<void> setAllPrintEnable(bool value) async {
    isAllPrintEnabled.value = value;
    await prefs.setIsAllPrintEnabled(
      isAllPrintEnabled: value,
    );
  }

  Future<void> setSalesOnline(bool value) async {
    isSalesOnline.value = value;
    await prefs.setIsSalesOnline(
      isSalesOnline: value,
    );
    final dashboardController = Get.find<DashboardController>();
    dashboardController.isOnline.value = value;
  }

  Future<void> setPurchaseOnline(bool value) async {
    isPurchaseOnline.value = value;
    await prefs.setIsPurchaseOnline(
      isPurchaseOnline: value,
    );
  }

  Future<void> setZeroSalesAllowed(bool value) async {
    isZeroSalesAllowed.value = value;
    await prefs.setIsZeroSalesAllowed(
      isZeroAllowed: value,
    );
  }

  Future<void> setHasPrinter(bool value) async {
    isHasPrinter.value = value;
    await prefs.setHasPrinter(
      hasPrinter: value,
    );
  }

  Future<void> setSalesAutoApproved(bool value) async {
    isSalesAutoApproved.value = value;
    await prefs.setIsSalesAutoApprove(
      isSalesAutoApprove: value,
    );
  }

  Future<void> setPurchaseAutoApproved(bool value) async {
    isPurchaseAutoApproved.value = value;
    await prefs.setIsPurchaseAutoApprove(
      isPurchaseAutoApprove: value,
    );
  }

  Future<void> setShowBrandOnPurchase(bool value) async {
    isShowBrandOnPurchase.value = value;
    await prefs.setIsShowBrandOnPurchase(
      isShowBrandOnPurchase: value,
    );
    if (Get.isRegistered<CreatePurchaseController>()) {
      final purchaseController = Get.find<CreatePurchaseController>();
      purchaseController.isShowBrand.value = value;
    }
  }

  Future<void> setShowBrandOnSales(bool value) async {
    isShowBrandOnSales.value = value;
    await prefs.setIsShowBrandOnSales(
      isShowBrandOnSales: value,
    );

    if (Get.isRegistered<CreateSalesController>()) {
      final salesController = Get.find<CreateSalesController>();
      salesController.isShowBrand.value = value;
    }
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }

  Future<void> changePurchase(String? config) async {
    // Ensure the new configuration is valid and different from the current one
    if (config == null || config.isEmpty || config == selectedPurchase.value) {
      return;
    }

    // Check if the CreatePurchaseController is registered
    final isControllerRegistered = Get.isRegistered<CreatePurchaseController>();

    if (isControllerRegistered) {
      final purchaseController = Get.find<CreatePurchaseController>();

      // If there are purchase items, confirm with the user before clearing them
      if (purchaseController.purchaseItemList.value.isNotEmpty) {
        final isConfirm = await confirmationModal(
          msg: appLocalization.areYouSure,
        );

        if (!isConfirm) {
          return; // Exit if the user cancels the operation
        }

        // Clear purchase items and reset related properties
        purchaseController.purchaseItemList.value = [];
        purchaseController
          ..calculateAllSubtotal()
          ..prePurchase = null;
      }
    }

    // Delete all records in the purchase item database table
    await dbHelper.deleteAll(tbl: dbTables.tablePurchaseItem);

    // Update the selected purchase configuration
    selectedPurchase.value = config;

    // Save the new purchase configuration in preferences
    await prefs.setPurchaseConfig(config);

    // Update the purchaseMode in the controller (if registered)
    if (isControllerRegistered) {
      Get.find<CreatePurchaseController>().purchaseMode = config;
    }
  }
}

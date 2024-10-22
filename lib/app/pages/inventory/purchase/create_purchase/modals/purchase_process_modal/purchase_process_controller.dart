import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/entity/purchase.dart';
import '/app/entity/purchase_item.dart';
import '/app/entity/transaction_methods.dart';
import '/app/entity/user.dart';
import '/app/entity/vendor.dart';
import '/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';
import '/app/pages/inventory/purchase/create_purchase/modals/purchase_confirm_modal/purchase_confirm_view.dart';

class PurchaseProcessController extends BaseController {
  Purchase? prePurchase;
  final formKey = GlobalKey<FormState>();

  final netTotal = 0.00.obs;
  final purchaseSubTotal = 0.00.obs;
  final purchaseReturnValue = 0.00.obs;

  final showPurchaseItem = false.obs;
  final isHold = false.obs;
  final isShowClearIcon = false.obs;

  Rx<Purchase?> createdPurchase = Rx<Purchase?>(null);
  final purchaseItemList = Rx<List<PurchaseItem>>([]);

  final vendorManager = VendorManager();
  final userManager = UserManager().obs;
  final transactionMethodsManager = TransactionMethodsManager();
  final amountController = TextEditingController().obs;

  final returnMsg = 'due'.obs;

  PurchaseProcessController({
    required List<PurchaseItem> itemList,
    this.prePurchase,
  }) {
    purchaseItemList.value = itemList;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await baseInit();
    if (prePurchase != null) {
      if (prePurchase!.isHold == 1) {
        isHold.value = true;
      }

      if (prePurchase!.vendorId != null) {
        final data = await dbHelper.getAllWhr(
          tbl: dbTables.tableVendors,
          where: 'vendor_id == ?',
          whereArgs: [
            prePurchase!.vendorId.toString(),
          ],
        );

        if (data.isNotEmpty) {
          vendorManager.selectedItem.value = Vendor.fromJson(data.first);
          vendorManager.searchTextController.value.text =
              vendorManager.selectedItem.value!.name!;
        }
      }

      if (prePurchase!.methodId != null) {
        transactionMethodsManager.selectedItem.value =
            transactionMethodsManager.allItems.value?.firstWhereOrNull(
          (element) => element.methodId == prePurchase!.methodId,
        );
      }

      if (prePurchase!.salesById != null) {
        userManager.value.asController.selectedValue =
            userManager.value.asController.items?.firstWhereOrNull(
          (element) => element.userId == prePurchase!.salesById,
        );
      }

      FocusScope.of(Get.context!).unfocus();
      update();
      notifyChildrens();
      refresh();
    }
  }

  Future<void> baseInit() async {
    await transactionMethodsManager.getAll();
    transactionMethodsManager.selectedItem.value = transactionMethodsManager
        .allItems.value
        ?.firstWhereOrNull((element) => element.isDefault == 1);
    await userManager.value.fillAsController();
    userManager.value.asController.selectedValue =
        userManager.value.asController.items?.firstWhereOrNull(
      (element) => element.userId == LoggedUser().userId,
    );
    userManager.refresh();
    calculateAllSubtotal();
    purchaseReturnValue.value = purchaseSubTotal.value;
    netTotal.value = purchaseSubTotal.value;
  }

  void calculateAllSubtotal() {
    purchaseSubTotal.value = 0;

    for (final element in purchaseItemList.value) {
      purchaseSubTotal.value += element.subTotal ?? 0;
    }
    purchaseSubTotal
      ..value = purchaseSubTotal.value.toPrecision(2)
      ..refresh();
    update();
  }

  Future<void> updateVendor(Vendor? vendor) async {
    if (vendor != null) {
      vendorManager.searchTextController.value.text = vendor.name!;
      vendorManager.searchedItems.value = null;
      vendorManager.selectedItem.value = vendor;
      //FocusScope.of(Get.context!).unfocus();
    }
  }

  Future<Purchase?> generatePurchase() async {
    if (purchaseItemList.value.isEmpty) {
      return null;
    }

    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    calculateAllSubtotal();

    final purchase = Purchase(
      purchaseId: prePurchase == null ? timeStamp : prePurchase!.purchaseId,
      invoice: prePurchase == null ? timeStamp : prePurchase!.invoice,
      createdAt: prePurchase == null
          ? DateFormat('MM-dd-yyyy hh:mm a').format(
              DateTime.now(),
            )
          : prePurchase!.createdAt,
      updatedAt: prePurchase == null
          ? null
          : DateFormat('MM-dd-yyyy hh:mm a').format(
              DateTime.now(),
            ),
      process: 'purchase',
      subTotal: purchaseSubTotal.value,
      netTotal: netTotal.value,
      received: amountController.value.text.toDouble(),
      purchaseItem: purchaseItemList.value,
      createdById: LoggedUser().userId,
      createdBy: LoggedUser().username,
      salesBy: userManager.value.asController.selectedValue?.fullName,
      salesById: userManager.value.asController.selectedValue?.userId,
      isOnline: prePurchase == null ? 0 : prePurchase!.isOnline,
      purchaseMode: prePurchase == null
          ? await prefs.getPurchaseConfig()
          : prePurchase!.purchaseMode,
    );

    if (vendorManager.selectedItem.value != null) {
      purchase.setVendorData(
        vendorManager.selectedItem.value!,
      );
    }
    if (transactionMethodsManager.selectedItem.value != null) {
      purchase.setTransactionMethodData(
        transactionMethodsManager.selectedItem.value!,
      );
    }

    debugPrint(
      jsonEncode(
        purchase.toJson(),
      ),
      wrapWidth: 1024,
    );
    createdPurchase.value = purchase;

    update();
    notifyChildrens();
    refresh();

    return purchase;
  }

  Future<void> insertSaleToDb(Purchase purchase) async {
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tablePurchase,
      dataList: [
        purchase.toJson(),
      ],
    );
  }

  Future<void> showConfirmationDialog(
    BuildContext context,
  ) async {
    if (purchaseItemList.value.isEmpty) {
      toast(appLocalization.noDataFound);
      return;
    }
    if (!formKey.currentState!.validate()) return;

    final purchase = await generatePurchase();

    if (purchase == null) {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.somethingWentWrong,
      );
      return;
    }

    final isVendorNotSelected = vendorManager.selectedItem.value == null;
    final amountText = amountController.value.text;
    final amount = double.tryParse(amountText) ?? 0;

    if (isVendorNotSelected) {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.vendorIsRequired,
      );
      return;
    }
    purchase.subTotal = netTotal.value;

    if (amount >= netTotal.value) {
      purchase
        ..received = netTotal.value
        ..due = 0;
    } else {
      if (purchase.purchaseMode == 'purchase_with_mrp') {
        purchase
          ..due = 0
          ..received = amount
          ..netTotal = amount
          ..discount = netTotal.value - amount;
      } else {
        purchase
          ..due = netTotal.value - amount
          ..received = amount
          ..netTotal = netTotal.value;
      }
    }

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: appLocalization.purchaseConfirmation,
          subTitle: '',
          child: PurchaseConfirmView(
            purchase: purchase,
            isEdit: prePurchase != null,
          ),
        );
      },
    );

    if (confirmed != null && confirmed) {
      log('order process confirmed');
      Get.back(
        result: purchaseItemList.value,
      );
    }
  }

  Future<void> reset(BuildContext context) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );

    if (confirmation) {
      purchaseItemList.value = [];
      Get.back(
        result: purchaseItemList.value,
      );
    }
  }

  Future<void> hold(BuildContext context) async {
    final purchase = await generatePurchase();
    if (purchase == null) {
      toast('failed_to_generate_purchase'.tr);
      return;
    }
    purchase.isHold = 1;
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tablePurchase,
      dataList: [purchase.toJson()],
    );
    purchaseItemList.value.clear();
    Get.back(
      result: purchaseItemList,
    );
  }

  Future<void> addVendor() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.createVendor,
        subTitle: '',
        child: AddVendorModalView(),
      ),
    ) as Vendor?;

    if (result != null) {
      vendorManager.selectedItem.value = result;
      vendorManager.searchTextController.value.text = result.name!;
      vendorManager.searchedItems.value = null;
      update();
      notifyChildrens();
      refresh();
    }
  }

  void onAmountChange(String value) {}
}

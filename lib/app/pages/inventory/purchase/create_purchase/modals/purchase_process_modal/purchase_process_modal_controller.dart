import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/core/widget/common_confirmation_modal.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/purchase.dart';
import '/app/entity/purchase_item.dart';
import '/app/entity/transaction_methods.dart';
import '/app/entity/user.dart';
import '/app/entity/vendor.dart';
import '/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';

class PurchaseProcessModalController extends BaseController {
  Purchase? prePurchase;
  final formKey = GlobalKey<FormState>();

  final netTotal = 0.00.obs;
  final purchaseSubTotal = 0.00.obs;
  final purchaseReturnValue = 0.00.obs;

  final showPurchaseItem = false.obs;
  final isHold = false.obs;

  Rx<Purchase?> createdPurchase = Rx<Purchase?>(null);
  final purchaseItemList = Rx<List<PurchaseItem>>([]);

  final vendorManager = VendorManager();
  final userManager = UserManager().obs;
  final transactionMethodsManager = TransactionMethodsManager();
  final amountController = TextEditingController().obs;

  final returnMsg = 'due'.obs;

  PurchaseProcessModalController({
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
      purchaseItemList.value = prePurchase!.purchaseItem!;

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
      toast('you_removed_all_item'.tr);
      return;
    }
    if (!formKey.currentState!.validate()) return;

    final isZeroSalesAllowed = await prefs.getIsZeroSalesAllowed();
    final sales = await generatePurchase();

    if (sales == null) {
      toast('failed_to_generate_sales'.tr);
      return;
    }

    final isCustomerNotSelected = vendorManager.selectedItem.value == null;
    final isCustomerSelected = vendorManager.selectedItem.value != null;
    final amountText = amountController.value.text;
    final isAmountEmpty = amountText.isEmptyOrNull;
    final amount = double.tryParse(amountText) ?? 0;
    final isInvalidAmount = amount > 0 && amount < netTotal.value;

    if (isZeroSalesAllowed && isCustomerNotSelected && isAmountEmpty) {
      sales.received = netTotal.value;
    } else if (isZeroSalesAllowed && isCustomerNotSelected && isInvalidAmount) {
      toast('this_amount_is_not_valid'.tr);
      return;
    } else if (amount > netTotal.value && isCustomerSelected) {
      sales.received = netTotal.value;
    }

    if (!context.mounted) return;

/*    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: OrderProcessConfirmationView(
            sales: sales,
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
    }*/
  }

  Future<void> reset(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CommonConfirmationModal(
          title: 'are_you_sure'.tr,
        );
      },
    ).then(
      (value) {
        if (value == true) {
          purchaseItemList.value.clear();
          Get.back(
            result: purchaseItemList.value,
          );
        }
      },
    );
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
        title: 'add_vendor'.tr,
        subTitle: '',
        child: AddVendorModalView(),
      ),
    ) as Vendor?;
    print('result: $result');

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

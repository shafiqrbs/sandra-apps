import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/core_model/logged_user.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/model/customer.dart';
import '/app/model/sales.dart';
import '/app/model/sales_item.dart';
import '/app/model/transaction_methods.dart';
import '/app/model/user.dart';

abstract class PaymentGatewayController extends BaseController {}

class SalesProcessModalController extends BaseController {
  Sales? preSales;
  Rx<Sales?> createdSales = Rx<Sales?>(null);

  final showSalesItem = false.obs;
  final isHold = false.obs;

  SalesProcessModalController({
    required List<SalesItem> salesItemList,
    this.preSales,
  }) {
    this.salesItemList.value = salesItemList;
  }

  final salesItemList = <SalesItem>[].obs;

  final formKey = GlobalKey<FormState>();

  final selectedPaymentMode = 'cash'.obs;
  final discountType = 'flat'.obs;
  final returnMsg = 'due'.obs;

  final paymentDiscountController = TextEditingController().obs;
  final amountController = TextEditingController().obs;
  final paymentTrxIdController = TextEditingController().obs;
  final paymentMobileController = TextEditingController().obs;
  final addRemarkController = TextEditingController().obs;

  final customerManager = CustomerManager();
  final transactionMethodsManager = TransactionMethodsManager();
  final userManager = UserManager().obs;

  final discountTypeController = ValueNotifier<bool>(false).obs;
  final showProfit = ValueNotifier<bool>(false).obs;
  final printWithoutDiscount = ValueNotifier<bool>(false).obs;

  final salesSubTotal = 0.00.obs;
  final salesDiscount = 0.00.obs;
  final salesVat = 0.00.obs;
  final netTotal = 0.00.obs;
  final salesReceive = 0.00.obs;
  final salesPurchasePrice = 0.00.obs;
  final salesDiscountPercent = 0.00.obs;
  final salesReturnValue = 0.00.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await baseInit();
    if (preSales != null) {
      print('Pre sales is not null');
      salesItemList.value = preSales!.salesItem!;

      if (preSales!.isHold == 1) {
        isHold.value = true;
      }
      if (preSales!.printWithoutDiscount == 1) {
        printWithoutDiscount.value.value = true;
      }
      if (preSales!.customerId != null) {
        final data = await dbHelper.getAllWhr(
          tbl: tableCustomers,
          where: 'customer_id == ?',
          whereArgs: [
            preSales!.customerId.toString(),
          ],
        );

        if (data.isNotEmpty) {
          customerManager.selectedItem.value = Customer.fromJson(data.first);
          customerManager.searchTextController.value.text =
              customerManager.selectedItem.value!.name!;
        }
      }
      print('preSales!.methodId: ${preSales!.methodId}');

      if (preSales!.methodId != null) {
        transactionMethodsManager.selectedItem.value =
            transactionMethodsManager.allItems.value?.firstWhereOrNull(
          (element) => element.methodId == preSales!.methodId,
        );
      }

      if (preSales!.salesById != null) {
        userManager.value.asController.selectedValue =
            userManager.value.asController.items?.firstWhereOrNull(
          (element) => element.userId == preSales!.salesById,
        );
      }

      FocusScope.of(Get.context!).unfocus();
      selectedPaymentMode.refresh();
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
    salesReturnValue.value = salesSubTotal.value;
    netTotal.value = salesSubTotal.value;
    discountTypeController.value.addListener(
      () {
        if (discountTypeController.value.value) {
          discountType.value = 'percent';
        } else {
          discountType.value = 'flat';
        }
        onDiscountChange(paymentDiscountController.value.text);
      },
    );
    showProfit.value.addListener(showProfit.refresh);
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
      //FocusScope.of(Get.context!).unfocus();
    }
  }

  Future<Sales?> generateSales() async {
    if (salesItemList.isEmpty) {
      return null;
    }

    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    calculateAllSubtotal();

    final sales = Sales(
      salesId: preSales == null ? timeStamp : preSales!.salesId,
      invoice: preSales == null ? timeStamp : preSales!.invoice,
      createdAt: preSales == null
          ? DateFormat('MM-dd-yyyy hh:mm a').format(
              DateTime.now(),
            )
          : preSales!.createdAt,
      updatedAt: preSales == null
          ? null
          : DateFormat('MM-dd-yyyy hh:mm a').format(
              DateTime.now(),
            ),
      process: 'sales',
      printWithoutDiscount: printWithoutDiscount.value.value ? 1 : 0,
      subTotal: salesSubTotal.value,
      discountType: discountType.value,
      discount: salesDiscount.value,
      netTotal: netTotal.value,
      vat: salesVat.value,
      discountCalculation: paymentDiscountController.value.text.toDouble(),
      received: amountController.value.text.toDouble(),
      salesItem: salesItemList,
      createdById: LoggedUser().userId,
      createdBy: LoggedUser().username,
      salesBy: userManager.value.asController.selectedValue?.fullName,
      salesById: userManager.value.asController.selectedValue?.userId,
      isOnline: preSales == null ? 0 : preSales!.isOnline,
    );

    if (customerManager.selectedItem.value != null) {
      sales.setCustomerData(customerManager.selectedItem.value!);
    }
    if (transactionMethodsManager.selectedItem.value != null) {
      sales.setTransactionMethodData(
          transactionMethodsManager.selectedItem.value!);
    }

    debugPrint(
      jsonEncode(
        sales.toJson(),
      ),
      wrapWidth: 1024,
    );
    createdSales.value = sales;

    update();
    notifyChildrens();
    refresh();

    return sales;
  }

  Future<void> insertSaleToDb(Sales sales) async {
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: tableSale,
      dataList: [
        sales.toJson(),
      ],
    );
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    if (salesItemList.isEmpty) {
      toast('you_removed_all_item'.tr);
      return;
    }
    if (!formKey.currentState!.validate()) return;

    final isZeroSalesAllowed = await prefs.getIsZeroSalesAllowed();
    final sales = await generateSales();

    if (sales == null) {
      toast('failed_to_generate_sales'.tr);
      return;
    }

    final isCustomerNotSelected = customerManager.selectedItem.value == null;
    final isCustomerSelected = customerManager.selectedItem.value != null;
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

    if (Get.isRegistered<OrderProcessConfirmationController>()) {
      Get.delete<OrderProcessConfirmationController>();
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: OrderProcessConfirmationView(
            sales: sales,
            isEdit: preSales != null,
          ),
        );
      },
    );

    if (confirmed != null && confirmed) {
      log('order process confirmed');
      Get.back(
        result: salesItemList,
      );
    }
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
          salesItemList.clear();
          Get.back(result: salesItemList);
        }
      },
    );
  }

  Future<void> hold(BuildContext context) async {
    final sales = await generateSales();
    if (sales == null) {
      toast('failed_to_generate_sales'.tr);
      return;
    }
    sales.isHold = 1;
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: tableSale,
      dataList: [sales.toJson()],
    );
    salesItemList.clear();
    Get.back(result: salesItemList);
  }
}

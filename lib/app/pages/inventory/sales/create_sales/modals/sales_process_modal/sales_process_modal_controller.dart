import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/importer.dart';

import '/app/core/abstract_controller/payment_gateway_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/core/widget/common_confirmation_modal.dart';
import '/app/entity/customer.dart';
import '/app/entity/sales.dart';
import '/app/entity/sales_item.dart';
import '/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import '/app/pages/inventory/sales/create_sales/modals/order_process_confirmation_modal/order_process_confirmation_view.dart';

class SalesProcessModalController extends PaymentGatewayController {
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

  @override
  Future<void> onInit() async {
    super.onInit();
    await baseInit();
    if (preSales != null) {
      if (preSales!.isHold == 1) {
        isHold.value = true;
      }
      if (preSales!.printWithoutDiscount == 1) {
        printWithoutDiscount.value.value = true;
      }
      if (preSales!.customerId != null) {
        final data = await dbHelper.getAllWhr(
          tbl: dbTables.tableCustomers,
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
    if (kDebugMode) {
      print('salesItemList: ${jsonEncode(salesItemList)}');
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
    salesReturnValue.value = salesSubTotal.value;
    netTotal.value = salesSubTotal.value;
    // discountTypeController.value.addListener(
    //   () {
    //     if (discountTypeController.value.value) {
    //       discountType.value = 'percent';
    //     } else {
    //       discountType.value = 'flat';
    //     }
    //     onDiscountChange(paymentDiscountController.value.text);
    //   },
    // );
    // showProfit.value.addListener(showProfit.refresh);
  }

  void onDiscountChange(String value) {
    final discountValue = double.tryParse(value) ?? 0;

    if (discountType.value == 'flat') {
      handleDiscountChange(discountValue, null);
    } else if (discountType.value == 'percent') {
      // Calculate percentage discount
      final percentDiscount =
          (salesSubTotal.value * discountValue / 100).toPrecision(2);
      handleDiscountChange(percentDiscount, discountValue);
    }

    netTotal.value = (salesSubTotal.value - salesDiscount.value).toPrecision(2);
    salesReturnValue.value = netTotal.value;

    onAmountChange(
      amountController.value.text.isEmptyOrNull
          ? '0'
          : amountController.value.text,
    );

    salesDiscount.refresh();
    netTotal.refresh();
    update();
    notifyChildrens();
    refresh();
  }

  void handleDiscountChange(double discountValue, double? percentValue) {
    if (discountValue > salesSubTotal.value) {
      toast(appLocalization.doNotAllowDiscountValueMoreThenSubtotalValue);
      paymentDiscountController.value.text = '0';
      salesDiscount.value = 0;
      netTotal.value = 0;
      salesReturnValue.value = salesSubTotal.value;
      return;
    }

    salesDiscount.value = discountValue;

    if (percentValue != null) {
      salesDiscountPercent.value = percentValue;
    }
  }

  void onAmountChange(String value) {
    if (value.isNotEmpty) {
      final returnValue = netTotal.value - value.toDouble();
      returnMsg.value = returnValue < 0 ? 'Return' : 'Due';
      salesReturnValue.value = returnValue.toPrecision(2).abs();
    } else {
      returnMsg.value = 'Due';
      salesReturnValue.value = 0.00;
    }
  }

  void calculateAllSubtotal() {
    salesSubTotal.value = 0;
    salesPurchasePrice.value = 0;

    for (final element in salesItemList) {
      salesSubTotal.value += element.subTotal ?? 0;
      salesPurchasePrice.value += element.purchasePrice! * element.quantity!;
    }
    salesSubTotal.value = salesSubTotal.value.toPrecision(2).round().toDouble();
    salesPurchasePrice.value = salesPurchasePrice.value.toPrecision(2);

    salesSubTotal.refresh();
    salesPurchasePrice.refresh();
    update();
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
          ? DateFormat(apiDateFormat).format(
              DateTime.now(),
            )
          : preSales!.createdAt,
      updatedAt: preSales == null
          ? null
          : DateFormat(apiDateFormat).format(
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
      purchasePrice: salesPurchasePrice.value,
    );

    if (customerManager.selectedItem.value != null) {
      sales.setCustomerData(
        customerManager.selectedItem.value!,
      );
    }
    if (transactionMethodsManager.selectedItem.value != null) {
      sales.setTransactionMethodData(
        transactionMethodsManager.selectedItem.value!,
      );
    }

    createdSales.value = sales;

    update();
    notifyChildrens();
    refresh();

    return sales;
  }

  Future<void> insertSaleToDb(Sales sales) async {
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tableSale,
      dataList: [
        sales.toJson(),
      ],
    );
  }

  Future<void> showConfirmationDialog(
    BuildContext context,
  ) async {
    if (salesItemList.isEmpty) {
      toast(appLocalization.noDataFound);
      return;
    }
    if (!formKey.currentState!.validate()) return;

    final isZeroSalesAllowed = await prefs.getIsZeroSalesAllowed();
    final sales = await generateSales();

    if (sales == null) {
      toast(appLocalization.failed);
      return;
    }

    final isCustomerNotSelected = customerManager.selectedItem.value == null;
    final isCustomerSelected = customerManager.selectedItem.value != null;
    final amountText = amountController.value.text;
    final isAmountEmpty = amountText.isEmptyOrNull;
    final amount = (num.tryParse(amountText) ?? 0).toInt();
    final isInvalidAmount = amount >= 0 && amount < netTotal.value.toInt();

    if (kDebugMode) {
      print('isZeroSalesAllowed: $isZeroSalesAllowed');
      print('isCustomerNotSelected: $isCustomerNotSelected');
      print('isCustomerSelected: $isCustomerSelected');
      print('amountText: $amountText');
      print('isAmountEmpty: $isAmountEmpty');
      print('amount: $amount');
      print('isInvalidAmount: $isInvalidAmount');
    }

    if (isCustomerSelected) {
      if (amount == 0) {
        sales.due = netTotal.value;
      } else if (isInvalidAmount) {
        sales.due = netTotal.value - amount;
      } else {
        sales.due = 0;
      }
    } else {
      if (isZeroSalesAllowed) {
        if (amount == 0) {
          sales.received = netTotal.value;
        } else if (isInvalidAmount) {
          toast(appLocalization.eitherSelectCustomerOrEnterValidAmount);
          return;
        }
      } else {
        if (isInvalidAmount) {
          toast(appLocalization.theAmountMustBeEqualOrMoreThanNetTotal);
          return;
        }
      }
    }

    print('due: ${sales.due}');

    if (amount > netTotal.value) {
      sales.received = netTotal.value;
    }

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: appLocalization.orderProcessing,
          subTitle: '',
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
          title: appLocalization.areYouSure,
        );
      },
    ).then(
      (value) {
        if (value == true) {
          salesItemList.clear();
          Get.back(
            result: salesItemList,
          );
        }
      },
    );
  }

  Future<void> hold(BuildContext context) async {
    final sales = await generateSales();
    if (sales == null) {
      toast(appLocalization.failed);
      return;
    }
    sales.isHold = 1;
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tableSale,
      dataList: [sales.toJson()],
    );
    salesItemList.clear();
    Get.back(result: salesItemList);
  }

  Future<void> addCustomer() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.customer,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
    ) as Customer?;
    print('result: $result');

    if (result != null) {
      customerManager.selectedItem.value = result;
      customerManager.searchTextController.value.text = result.name!;
      customerManager.searchedItems.value = null;
      update();
      notifyChildrens();
      refresh();
    }
  }
}

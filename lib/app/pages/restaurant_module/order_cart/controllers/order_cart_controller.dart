import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/restaurant/table_invoice.dart';
import 'package:sandra/app/entity/stock.dart';
import 'package:sandra/app/entity/transaction_methods.dart';
import 'package:sandra/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';
import '/app/core/base/base_controller.dart';

class OrderCartController extends BaseController {
  List<String> orderCategoryList = [
    'Order taken by',
    'Mr. Alex',
    'John Doe',
  ];

  final isAdditionalTableSelected = false.obs;
  final showQuantityUpdateList = <int>[].obs;

  var itemQuantities =
      List<int>.filled(10, 1).obs; // Default quantity of 1 for 10 items

  final customerManager = CustomerManager();
  final isShowClearIcon = false.obs;
  final transactionMethodsManager = TransactionMethodsManager();
  final discountTypeController = ValueNotifier<bool>(false).obs;
  final paymentDiscountController = TextEditingController().obs;
  final amountController = TextEditingController().obs;
  final discountType = 'flat'.obs;
  final returnMsg = 'Due'.obs;
  final salesSubTotal = 0.00.obs;
  final salesDiscount = 0.00.obs;
  final salesVat = 0.00.obs;
  final netTotal = 0.00.obs;
  final salesReceive = 0.00.obs;
  final salesPurchasePrice = 0.00.obs;
  final salesDiscountPercent = 0.00.obs;
  final salesReturnValue = 0.00.obs;

  final tableInvoice = Rx<TableInvoice?>(null);
  final cartItems = Rx<List<Stock>?>(null);
  final selectedTableId = 0.obs;
  final tableName = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final arg = await Get.arguments;
    if (arg != null) {
      final invoice = arg['tableInvoice'];
      selectedTableId.value = arg['tableId'];
      tableName.value = arg['tableName'];
      tableInvoice.value = TableInvoice.fromJson(invoice[0]);
    }
    initializeCartItems();
  }

  void initializeCartItems() {
    if (tableInvoice.value?.items != null) {
      cartItems.value = tableInvoice.value!.items;
      itemQuantities.value = List<int>.filled(
        cartItems.value!.length,
        1,
      );
      for (int i = 0; i < cartItems.value!.length; i++) {
        final cartItem = cartItems.value![i];
        if (cartItem.quantity! > 1) {
          itemQuantities[i] = cartItem.quantity!;
        }
      }
    }
  }

  void changeAdditionTableSelection() {
    isAdditionalTableSelected.value = !isAdditionalTableSelected.value;
  }

  Future<void> updateCartItems() async {
    final subTotal = calculateTotalAmount(cartItems.value!);

    await dbHelper.updateWhere(
      tbl: dbTables.tableTableInvoice,
      data: {
        'items': jsonEncode(cartItems.value),
        'subtotal': subTotal,
      },
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    // get updated cart items
    final updatedCartItems = await dbHelper.getAllWhr(
      tbl: dbTables.tableTableInvoice,
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );
    tableInvoice.value = TableInvoice.fromJson(updatedCartItems[0]);
    cartItems.value = tableInvoice.value!.items;
    tableInvoice.refresh();

    // update restaurant controller addSelectedFoodItem value
    final restaurantController = Get.find<RestaurantHomeController>();
    restaurantController.addSelectedFoodItem.value[selectedTableId.value] =
        cartItems.value ?? [];
    restaurantController.addSelectedFoodItem.refresh();
  }

  Future<void> increaseQuantity(int index) async {
    itemQuantities[index]++;
    // update invoiceTable items quantity
    cartItems.value![index].quantity = itemQuantities[index];
    updateCartItems();
  }

  void decreaseQuantity(int index) {
    if (itemQuantities[index] > 1) {
      itemQuantities[index]--;
      // update invoiceTable items quantity
      cartItems.value![index].quantity = itemQuantities[index];
      updateCartItems();
    }
  }

  void showQuantityUpdate(int index) {
    if (showQuantityUpdateList.contains(index)) {
      showQuantityUpdateList.remove(index);
    } else {
      showQuantityUpdateList.add(index);
    }
  }

  Future<void> addCustomer() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.customer,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
    ) as Customer?;

    if (result != null) {
      customerManager.selectedItem.value = result;
      customerManager.searchTextController.value.text = result.name!;
      customerManager.searchedItems.value = null;
      update();
      notifyChildrens();
      refresh();
    }
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
      //FocusScope.of(Get.context!).unfocus();
    }
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

  double calculateTotalAmount(List<Stock> items) {
    double totalAmount = 0;
    for (final Stock item in items) {
      totalAmount += item.salesPrice! * item.quantity!;
    }
    return totalAmount;
  }
}

import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/core/core_model/logged_user.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/values/app_strings.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/restaurant/table_invoice.dart';
import 'package:sandra/app/entity/sales.dart';
import 'package:sandra/app/entity/sales_item.dart';
import 'package:sandra/app/entity/stock.dart';
import 'package:sandra/app/entity/transaction_methods.dart';
import 'package:sandra/app/entity/user.dart';
import 'package:sandra/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import 'package:sandra/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import 'package:sandra/app/pages/inventory/sales/create_sales/modals/order_process_confirmation_modal/order_process_confirmation_controller.dart';
import 'package:sandra/app/pages/inventory/sales/create_sales/modals/order_process_confirmation_modal/order_process_confirmation_view.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';
import '/app/core/base/base_controller.dart';

class OrderCartController extends BaseController {
  List<String> orderCategoryList = [
    'Order taken by',
    'Mr. Alex',
    'John Doe',
  ];
  final selectedOrderCategory = 'Order taken by'.obs;

  final isAdditionalTableSelected = false.obs;
  final isAllPrintEnabled = false.obs;
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
  final salesItemList = <SalesItem>[].obs;
  final selectedTableId = 0.obs;
  final tableName = ''.obs;
  final userManager = UserManager().obs;
  final printWithoutDiscount = ValueNotifier<bool>(false).obs;
  Rx<Sales?> createdSales = Rx<Sales?>(null);
  final formKey = GlobalKey<FormState>();
  Timer? timer;
  final isTableEnabled = false.obs;

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
    isTableEnabled.value = await prefs.getIsisTableEnabled();
    isAllPrintEnabled.value = await prefs.getIsAllPrintEnabled();
    await initializeCartItems();
    await getSalesUser();
    await initializeVariables();
  }

  Future<void> initializeVariables() async {
    final getDataFromDb = await dbHelper.getAllWhr(
      tbl: dbTables.tableTableInvoice,
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    salesSubTotal.value = getDataFromDb[0]['subtotal'].toDouble();

    salesVat
      ..value = calculateVatAmount(
        SetUp().vatPercentage?.toDouble() ?? 0,
      )
      ..refresh();
  }

  Future<void> initializeCartItems() async {
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

    await transactionMethodsManager.getAll();
    transactionMethodsManager.selectedItem.value = transactionMethodsManager
        .allItems.value
        ?.firstWhereOrNull((element) => element.isDefault == 1);
  }

  Future<void> getSalesUser() async {
    final users = await dbHelper.getAll(tbl: dbTables.tableUsers);
    final List<User> userList = [];
    orderCategoryList.removeRange(1, orderCategoryList.length);
    for (final user in users) {
      userList.add(User.fromJson(user));
      orderCategoryList.add(user['full_name']);
    }
  }

  void changeAdditionTableSelection() {
    isAdditionalTableSelected.value = !isAdditionalTableSelected.value;
  }

  Future<void> updateCartItems() async {
    salesSubTotal.value = calculateTotalAmount(cartItems.value!);
    salesVat.value = calculateVatAmount(
      SetUp().vatPercentage?.toDouble() ?? 0,
    );
    //netTotal.value = subTotal + salesVat.value - salesDiscount.value;

    await dbHelper.updateWhere(
      tbl: dbTables.tableTableInvoice,
      data: {
        'items': jsonEncode(cartItems.value),
        'subtotal': salesSubTotal.value,
        'total': netTotal.value,
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
    netTotal.refresh();

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

  void startQuantityDecreaseTimer(int index) {
    stopQuantityTimer(); // Ensure no other timer is running
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (t) {
        decreaseQuantity(index);
      },
    );
  }

  void startQuantityIncreaseTimer(int index) {
    stopQuantityTimer(); // Ensure no other timer is running
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (t) {
        increaseQuantity(index);
      },
    );
  }

  void stopQuantityTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
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

    //netTotal.value = (salesSubTotal.value - salesDiscount.value).toPrecision(2);
    salesSubTotal.value =
        (salesSubTotal.value - salesDiscount.value).toPrecision(2);
    salesVat.value = calculateVatAmount(
      SetUp().vatPercentage?.toDouble() ?? 0,
    );
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

  double calculateVatAmount(
    double percentage,
  ) {
    double vatAmount = 0;
    vatAmount = (salesSubTotal.value * (percentage / 100)).toPrecision(2);
    netTotal
      ..value = (salesSubTotal.value + vatAmount).toPrecision(2)
      ..refresh();
    return vatAmount;
  }

  void calculateAllSubtotal() {
    salesSubTotal.value = 0;
    salesPurchasePrice.value = 0;

    for (final element in salesItemList) {
      salesSubTotal.value += element.subTotal ?? 0;
      salesPurchasePrice.value += element.purchasePrice! * element.quantity!;
    }
    salesSubTotal.value = salesSubTotal.value.toPrecision(2);
    salesPurchasePrice.value = salesPurchasePrice.value.toPrecision(2);
    //netTotal.value = salesSubTotal.value;

    salesSubTotal.refresh();
    salesPurchasePrice.refresh();
    //netTotal.refresh();
    update();
  }

  Future<Sales?> generateSales() async {
    if (salesItemList.isEmpty) {
      return null;
    }

    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    calculateAllSubtotal();

    final sales = Sales(
      salesId: timeStamp,
      invoice: timeStamp,
      createdAt: DateFormat(apiDateFormat).format(
        DateTime.now(),
      ),
      updatedAt: null,
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
      salesBy: selectedOrderCategory.value,
      //salesBy: userManager.value.asController.selectedValue?.fullName,
      salesById: userManager.value.asController.selectedValue?.userId,
      isOnline: 0,
      tokenNo: generateTokenWithInvoiceAndTimestamp(timeStamp),
      approvedBy: LoggedUser().username,
      approvedById: LoggedUser().userId,
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

  Future<void> showConfirmationDialog(
    BuildContext context,
  ) async {
    // insert cartItems into salesItemList
    if (cartItems.value == null) return;
    for (final Stock item in cartItems.value!) {
      final salesItem = SalesItem(
        stockId: item.globalId,
        barcode: item.barcode,
        stockName: item.name,
        brandName: item.brandName,
        unit: item.unit,
        mrpPrice: item.salesPrice,
        salesPrice: item.salesPrice,
        discountPrice: 0,
        purchasePrice: item.purchasePrice,
        itemPercent: 0,
        customPrice: 0,
        quantity: item.quantity,
        subTotal: item.salesPrice! * item.quantity!,
        discountPercent: 0,
      );
      salesItemList.add(salesItem);
    }

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
    final amount = double.tryParse(amountText) ?? 0;
    final isInvalidAmount = amount > 0 && amount < netTotal.value;

    if (!isZeroSalesAllowed &&
        isCustomerNotSelected &&
        amount < netTotal.value) {
      toast(appLocalization.dueSalesWithoutCustomer);
      return;
    }

    if (isZeroSalesAllowed && isCustomerNotSelected && isAmountEmpty) {
      sales.received = netTotal.value;
    } else if (isZeroSalesAllowed && isCustomerNotSelected && isInvalidAmount) {
      toast(appLocalization.thisAmountIsNotValid);
      return;
    }

    if (amount > netTotal.value) {
      sales.received = netTotal.value;
    }

    if (!context.mounted) return;

    final orderProcessConfirmationController = Get.put(
      OrderProcessConfirmationController(
        sales: sales,
        isEdit: false,
      ),
    );
    await orderProcessConfirmationController.saveSales();

    /*final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: appLocalization.orderProcessing,
          subTitle: '',
          child: OrderProcessConfirmationView(
            sales: sales,
            isEdit: false,
            //isEdit: preSales != null,
          ),
        );
      },
    );

    if (confirmed != null && confirmed) {
      log('order process confirmed');
      Get.back(
        result: cartItems.value,
      );
    }*/
    salesSubTotal.value = 0;
    salesItemList.clear();
  }

  void generateSalesItem() {
    if (cartItems.value == null) return;
    salesItemList.clear();
    for (final Stock item in cartItems.value!) {
      final salesItem = SalesItem(
        stockId: item.globalId,
        barcode: item.barcode,
        stockName: item.name,
        brandName: item.brandName,
        unit: item.unit,
        mrpPrice: item.salesPrice,
        salesPrice: item.salesPrice,
        discountPrice: 0,
        purchasePrice: item.purchasePrice,
        itemPercent: 0,
        customPrice: 0,
        quantity: item.quantity,
        subTotal: item.salesPrice! * item.quantity!,
        discountPercent: 0,
      );
      salesItemList.add(salesItem);
    }
  }

  Future<void> kitchenPrint(BuildContext context) async {
    try {
      generateSalesItem();
      final sales = await generateSales();
      if (sales == null) return;
      final printController = Get.put(PrinterController());
      final isPrinted = await printController.printRestaurantKitchen(
        sales: sales,
        table: tableName.value,
        orderTakenBy: selectedOrderCategory.value == 'Order taken by'
            ? ''
            : selectedOrderCategory.value,
      );

      if (isPrinted) {
        toast(appLocalization.success);
        return;
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return DialogPattern(
                title: appLocalization.printerSetup,
                subTitle: appLocalization.connectYourPrinter,
                child: PrinterConnectModalView(),
              );
            },
          );
        }
      }
    } catch (e, err) {
      if (kDebugMode) {
        print('error: $e, $err');
      }
      toast(appLocalization.failed);
    }
  }

  Future<void> printSalesWithToken(BuildContext context) async {
    await tokenPrint(context);

    await salesPrint(context);
  }

  Future<void> printAll(BuildContext context) async {
    await kitchenPrint(context);

    await tokenPrint(context);

    await salesPrint(context);
  }

  Future<void> tokenPrint(BuildContext context) async {
    try {
      generateSalesItem();
      final sales = await generateSales();
      if (sales == null) return;
      final printController = Get.put(PrinterController());
      final isPrinted = await printController.printRestaurantToken(
        sales: sales,
        table: tableName.value,
        orderTakenBy: selectedOrderCategory.value == 'Order taken by'
            ? ''
            : selectedOrderCategory.value,
      );

      if (isPrinted) {
        toast(appLocalization.success);
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return DialogPattern(
                title: appLocalization.printerSetup,
                subTitle: appLocalization.connectYourPrinter,
                child: PrinterConnectModalView(),
              );
            },
          );
        }
      }
    } catch (e) {
      toast(appLocalization.failed);
    }
  }

  Future<void> salesPrint(BuildContext context) async {
    try {
      generateSalesItem();
      final sales = await generateSales();
      if (sales == null) return;
      final printController = Get.put(PrinterController());
      final isPrinted = await printController.printSales(
        sales,
      );

      if (isPrinted) {
        toast(appLocalization.success);
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return DialogPattern(
                title: appLocalization.printerSetup,
                subTitle: appLocalization.connectYourPrinter,
                child: PrinterConnectModalView(),
              );
            },
          );
        }
      }
    } catch (e) {
      toast(appLocalization.failed);
    }
  }

  String generateTokenWithInvoiceAndTimestamp(String invoiceNumber) {
    // Get the last two digits of the current timestamp (milliseconds)
    int timestampPart = DateTime.now().millisecondsSinceEpoch %
        100; // Last two digits of the timestamp

    // Get the last two digits of the invoice number
    int invoicePart =
        int.parse(invoiceNumber) % 100; // Last two digits of the invoice number

    // Combine the two parts to form a 4-digit token
    int token = (invoicePart * 100) + timestampPart;

    return token.toString();
  }

  void deleteItem(int index) {
    // delete item from cartItems
    cartItems.value!.removeAt(index);
    updateCartItems();
  }

  void changeDiscountType(bool value) {
    discountType.value = value ? 'percent' : 'flat';
    onDiscountChange(paymentDiscountController.value.text);
  }
}

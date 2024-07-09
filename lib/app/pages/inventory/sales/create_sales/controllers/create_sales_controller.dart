import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/routes/app_pages.dart';
import '/app/entity/sales.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/entity/sales_item.dart';
import '/app/entity/stock.dart';

class CreateSalesController extends BaseController {
  Sales? preSales;
  final salesItemList = Rx<List<SalesItem>>([]);
  final stockList = Rx<List<Stock>>([]);
  final selectedStock = Rx<Stock?>(null);
  final qtyFocusNode = FocusNode().obs;

  final stockMrpController = TextEditingController().obs;
  final stockQtyController = TextEditingController().obs;
  final stockDiscountController = TextEditingController().obs;
  final stockTotalController = TextEditingController().obs;
  final stockDiscountPercentController = TextEditingController().obs;
  final searchController = TextEditingController().obs;

  final isSalesItemModalOpen = false.obs;
  final showSalesItem = false.obs;

  final printWithoutDiscount = ValueNotifier<bool>(false).obs;
  final discountTypeController = ValueNotifier<bool>(false).obs;

  //int
  final salesSubTotal = 0.00.obs;
  final salesDiscount = 0.00.obs;
  final salesVat = 0.00.obs;
  final salesTotal = 0.00.obs;
  final salesReceive = 0.00.obs;
  final salesPurchasePrice = 0.00.obs;
  final salesDiscountPercent = 0.00.obs;
  final salesReturnValue = 0.00.obs;
  final selectedTabNo = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    print('I am in CreateSalesController');
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.isNotEmpty && args['sales'] != null) {
      setData(args['sales'] as Sales);
    }
  }

  void goToListPage() {
    Get.offNamed(
      Routes.salesList,
    );
  }

  void setData(
    Sales sales,
  ) {
    preSales = sales;
    salesItemList.value = sales.salesItem ?? [];
    calculateAllSubtotal();
  }

  void calculateAllSubtotal() {
    salesSubTotal.value = 0;
    salesDiscount.value = 0.00;
    salesVat.value = 0.00;
    salesTotal.value = 0.00;
    salesReceive.value = 0.00;
    salesDiscountPercent.value = 0.00;

    for (final element in salesItemList.value) {
      salesSubTotal.value += element.subTotal ?? 0;
      salesPurchasePrice.value +=
          (element.purchasePrice ?? 0) * element.quantity!;
    }

    salesTotal.value = salesSubTotal.value.toPrecision(2);
    salesSubTotal.refresh();
    update();
  }

  Future<void> onClearSearchField() async {
    selectedStock.value = null;
    searchController.value.clear();
    searchController.refresh();
    stockList
      ..value = []
      ..refresh();
  }

  Future<void> getStocks(
    String? pattern,
  ) async {
    searchController.refresh();
    selectedStock.value = null;

    if (pattern == null || pattern.isEmpty) {
      stockList.value = [];
      return;
    }

    final stocks = await dbHelper.getAllWhr(
      tbl: dbTables.tableStocks,
      where: "name LIKE '$pattern%'",
      whereArgs: [],
      limit: 100,
    );

    stockList
      ..value = stocks.map(Stock.fromJson).toList()
      ..refresh();
  }

  Future<void> addSaleItem({
    required String process,
  }) async {
    if (kDebugMode) {
      print('on addSaleItem called');
    }

    // Check if a stock is selected
    if (selectedStock.value == null) {
      toast('select_stock'.tr);
      return;
    }

    // Extract values from controllers
    final stock = selectedStock.value!;
    final stockQty = double.tryParse(stockQtyController.value.text) ?? 0.0;
    final stockMrp = double.tryParse(stockMrpController.value.text) ??
        stock.salesPrice ??
        0.0;
    final discountPercent =
        double.tryParse(stockDiscountPercentController.value.text) ?? 0.0;

    // Create a new SalesItem instance
    final salesItem = SalesItem(
      stockId: stock.itemId,
      stockName: stock.name ?? '',
      quantity: stockQty.toPrecision(2),
      brandName: stock.brandName,
    );

    // Determine salesItem details based on process type
    if (process == 'inline' ||
        (stock.salesPrice == stockMrp && discountPercent == 0)) {
      // Inline process or no discount
      salesItem
        ..subTotal = stockQty * stock.salesPrice!
        ..mrpPrice = stock.salesPrice
        ..salesPrice = stock.salesPrice
        ..discountPercent = 0;
    } else if (stock.salesPrice != stockMrp) {
      // MRP changed
      salesItem
        ..subTotal = stockQty * stockMrp
        ..mrpPrice = stock.salesPrice
        ..salesPrice = stockMrp
        ..discountPrice = stock.salesPrice! - stockMrp
        ..discountPercent = 0;
    } else if (discountPercent > 0) {
      // Discount applied
      final discountPrice = (stock.salesPrice! * discountPercent) / 100;
      salesItem
        ..discountPrice = discountPrice
        ..salesPrice = stock.salesPrice! - discountPrice
        ..subTotal = stockQty * salesItem.salesPrice!
        ..mrpPrice = stock.salesPrice
        ..discountPercent = discountPercent;
    }

    // Update salesItem with calculated values
    salesItem
      ..purchasePrice =
          double.parse(stock.purchasePrice?.toStringAsFixed(2) ?? '0')
      ..subTotal = double.parse(
        salesItem.subTotal!.toStringAsFixed(2),
      )
      ..salesPrice = double.parse(
        salesItem.salesPrice!.toStringAsFixed(2),
      );

    // Update salesSubTotal value
    salesSubTotal
      ..value += salesItem.subTotal!
      ..value = salesSubTotal.value.toPrecision(2);

    // Add salesItem to the list and reset state
    salesItemList.value.add(salesItem);
    resetAfterItemAdd();
  }

  void resetAfterItemAdd() {
    selectedStock.value = null;
    searchController.value.clear();
    stockMrpController.value.clear();
    stockQtyController.value.clear();
    stockDiscountPercentController.value.clear();
    stockList.value = [];
    salesItemList.refresh();
  }

  Future<void> onStockSelection(Stock? stock) async {
    if (stock == null) return;

    selectedStock.value = stock;
    searchController.value.text = stock.name ?? '';
    qtyFocusNode.value.requestFocus();
    stockQtyController.value.text = '';
    stockMrpController.value.text =
        selectedStock.value?.salesPrice?.toString() ?? '';
    stockDiscountPercentController.value.text = '';

    stockQtyController.refresh();
    stockMrpController.refresh();
    stockDiscountPercentController.refresh();
    stockList
      ..value = []
      ..refresh();
  }

  Future<void> onQtyChange(
    num value,
    int index,
  ) async {
    final item = salesItemList.value[index];
    salesItemList.value[index]
      ..quantity = value
      ..subTotal = (item.salesPrice! * value).toDouble().toPrecision(2);

    calculateAllSubtotal();
  }

  Future<void> onSearchedStockQtyChange(
    num value,
    int index,
  ) async {}

  Future<void> onSearchedStockQtyEditComplete(
    num value,
    int index,
  ) async {
    stockQtyController.value.text = value.toString();
    selectedStock
      ..value = stockList.value[index]
      ..refresh();
    addSaleItem(
      process: 'inline',
    );
  }

  Future<void> onDiscountChange(
    num value,
    int index,
  ) async {
    log('onDiscountChange called');
    final item = salesItemList.value[index];
    final mrpPrice = item.mrpPrice!;

    salesItemList.value[index]
      ..discountPrice = double.parse(
        ((mrpPrice * value.toDouble()) / 100).toStringAsFixed(2),
      )
      ..salesPrice = double.parse(
        (mrpPrice - item.discountPrice!).toStringAsFixed(2),
      )
      ..subTotal = double.parse(
        (item.salesPrice! * item.quantity!).toStringAsFixed(2),
      )
      ..discountPercent = double.parse(
        value.toDouble().toStringAsFixed(2),
      );

    calculateAllSubtotal();
  }

  Future<void> onSalesPriceChange(
    num value,
    int index,
  ) async {
    log('onSalesPriceChange called');
    final item = salesItemList.value[index];
    salesItemList.value[index]
      ..salesPrice = value
      ..subTotal = double.parse(
        (item.salesPrice! * item.quantity!).toStringAsFixed(2),
      )
      ..discountPrice = double.parse(
        (item.mrpPrice! - item.salesPrice!).toStringAsFixed(2),
      );

    calculateAllSubtotal();
  }

  Future<void> onItemRemove(
    int index,
  ) async {
    salesItemList.value.removeAt(index);
    calculateAllSubtotal();
    salesItemList.refresh();
  }

  void updateSalesItemList(value) {
    salesItemList.value = value;
  }
}

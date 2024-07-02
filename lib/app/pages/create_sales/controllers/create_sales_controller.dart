import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/model/sales_item.dart';
import '/app/model/stock.dart';

class CreateSalesController extends BaseController {
  final salesItemList = <SalesItem>[].obs;
  final stockList = <Stock>[].obs;
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
    salesItemList.add(salesItem);
    resetAfterItemAdd();
  }

  void resetAfterItemAdd() {
    selectedStock.value = null;
    searchController.value.clear();
    stockMrpController.value.clear();
    stockQtyController.value.clear();
    stockDiscountPercentController.value.clear();
    stockList.value = [];
  }
}

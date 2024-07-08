import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/global_modal/sales_process_modal/sales_process_modal_view.dart';
import 'package:getx_template/app/model/purchase_item.dart';
import 'package:getx_template/app/model/stock.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/model/sales_item.dart';

class CreatePurchaseController extends BaseController {
  String? purchaseMode;
  final purchaseItemList = Rx<List<PurchaseItem>>([]);
  final stockList = Rx<List<Stock>>([]);
  final selectedStock = Rx<Stock?>(null);
  final qtyFocusNode = FocusNode().obs;

  final stockMrpController = TextEditingController().obs;
  final stockQtyController = TextEditingController().obs;
  final stockDiscountController = TextEditingController().obs;
  final stockTotalController = TextEditingController().obs;
  final stockDiscountPercentController = TextEditingController().obs;
  final searchController = TextEditingController().obs;

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
    purchaseMode = await prefs.getPurchaseConfig();
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

    print('stockQty: $stockQty');
    print('stockMrp: $stockMrp');
    print('discountPercent: $discountPercent');
    print('purchaseMode: $purchaseMode');

    // Create a new SalesItem instance
    final purchaseItem = PurchaseItem(
      stockId: stock.itemId,
      stockName: stock.name ?? '',
      quantity: stockQty.toPrecision(2),
      brandName: stock.brandName,
    );

    // Calculate subTotal based on purchaseMode
    double? calculateSubTotal() {
      switch (purchaseMode) {
        case 'purchase_with_mrp':
          return stockQty * stockMrp;
        case 'purchase_price':
          return stockQty * (stock.purchasePrice ?? 0.0);
        case 'item_percent':
          return (stockMrp - ((stockMrp * discountPercent) / 100)) * stockQty;
        case 'total_price':
          if (process == 'inline') {
            return stockQty * (stock.purchasePrice ?? 0.0);
          }
      }
      return null;
    }

    purchaseItem.subTotal = calculateSubTotal();

    // Handle error if subTotal is null
    if (purchaseItem.subTotal == null) {
      toast('sub_total_error'.tr);
      return;
    }

    // Update salesSubTotal value
    salesSubTotal
      ..value += purchaseItem.subTotal!
      ..value = salesSubTotal.value.toPrecision(2);

    // Add salesItem to salesItemList
    purchaseItemList.value.add(purchaseItem);

    // Reset fields after item is added
    resetAfterItemAdd();

    print('salesItem.subTotal: ${purchaseItem.subTotal}');
  }

  void resetAfterItemAdd() {
    selectedStock.value = null;
    searchController.value.clear();
    stockMrpController.value.clear();
    stockQtyController.value.clear();
    stockDiscountPercentController.value.clear();
    stockList.value = [];
    purchaseItemList.refresh();
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

  @override
  Future<void> onQtyChange(
    num value,
    int index,
  ) async {
    purchaseItemList.value[index].quantity = value;
    final item = purchaseItemList.value[index];

    if (purchaseMode == 'purchase_with_mrp') {
    } else if (purchaseMode == 'purchase_price') {
    } else if (purchaseMode == 'item_percent') {
    } else if (purchaseMode == 'total_price') {}

    calculateAllSubtotal();
  }

  void calculateAllSubtotal() {
    salesSubTotal.value = 0;
    salesDiscount.value = 0.00;
    salesVat.value = 0.00;
    salesTotal.value = 0.00;
    salesReceive.value = 0.00;
    salesDiscountPercent.value = 0.00;

    for (final element in purchaseItemList.value) {
      salesSubTotal.value += element.subTotal ?? 0;
    }

    salesTotal.value = salesSubTotal.value.toPrecision(2);
    salesSubTotal.refresh();
    update();
  }

  Future<void> onSalesPriceChange(
      num value,
      int index,
      ) async {
    log('onSalesPriceChange called');
    final item = purchaseItemList.value[index];


    calculateAllSubtotal();
  }

  Future<void> onDiscountChange(
    num value,
    int index,
  ) async {
    log('onDiscountChange called');
    final item = purchaseItemList.value[index];

    calculateAllSubtotal();
  }

  Future<void> onClearSearchField() async {
    selectedStock.value = null;
    searchController.value.clear();
    searchController.refresh();
    stockList
      ..value = []
      ..refresh();
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

  void goToListPage() {}

  Future<void> onSave() async {
    if (purchaseItemList.value.isEmpty) {
      toast('please_select_item'.tr);
      return;
    }
  }

  Future<void> onItemRemove(
    int index,
  ) async {
    purchaseItemList.value.removeAt(index);
    calculateAllSubtotal();
    purchaseItemList.refresh();
  }
}

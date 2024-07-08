import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/abstract_controller/stock_selection_controller.dart';
import 'package:getx_template/app/model/purchase_item.dart';
import 'package:getx_template/app/model/stock.dart';
import 'package:nb_utils/nb_utils.dart';

class CreatePurchaseController extends StockSelectionController {
  String? purchaseMode;
  final purchaseItemList = Rx<List<PurchaseItem>>([]);
  final priceController = TextEditingController().obs;
  final selectedPurchase = ''.obs;

  //int
  final purchaseSubTotal = 0.00.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    purchaseMode = await prefs.getPurchaseConfig();
    selectedPurchase.value = await prefs.getPurchaseConfig();
  }

  Future<void> changePurchase(String? config) async {
    if (config != null) {
      selectedPurchase.value = config;
      await prefs.setPurchaseConfig(config);
    }
  }

  Future<void> onStockSelection(
    Stock? stock,
  ) async {
    if (stock == null) return;

    selectedStock.value = stock;
    searchController.value.text = stock.name ?? '';
    qtyFocusNode.value.requestFocus();
    stockQtyController.value.clear();

    if (purchaseMode == 'purchase_price') {
      priceController.value.text = stock.purchasePrice.toString();
    } else {
      priceController.value.text = stock.salesPrice.toString();
    }

    stockList
      ..value = []
      ..refresh();
  }

  Future<void> addPurchaseItem({
    required String process,
  }) async {
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
      price: stockMrp,
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
    purchaseSubTotal
      ..value += purchaseItem.subTotal!
      ..value = purchaseSubTotal.value.toPrecision(2);

    // Add salesItem to salesItemList
    purchaseItemList.value.add(purchaseItem);

    // Reset fields after item is added
    resetAfterItemAdd();
    purchaseItemList.refresh();

    print('salesItem.subTotal: ${purchaseItem.subTotal}');
  }

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
    purchaseSubTotal.value = 0;

    for (final element in purchaseItemList.value) {
      purchaseSubTotal.value += element.subTotal ?? 0;
    }

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
    addPurchaseItem(
      process: 'inline',
    );
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

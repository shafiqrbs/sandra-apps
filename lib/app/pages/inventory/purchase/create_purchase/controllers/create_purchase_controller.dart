import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/global_modal/sales_process_modal/sales_process_modal_view.dart';
import '/app/core/abstract_controller/sales_controller.dart';
import '/app/model/sales_item.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_controller.dart';

class CreatePurchaseController extends SalesController {
  String? purchaseMode;

  @override
  Future<void> onInit() async {
    super.onInit();
    purchaseMode = await prefs.getPurchaseConfig();
  }

  @override
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
    final salesItem = SalesItem(
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

    salesItem.subTotal = calculateSubTotal();

    // Handle error if subTotal is null
    if (salesItem.subTotal == null) {
      toast('sub_total_error'.tr);
      return;
    }

    // Update salesSubTotal value
    salesSubTotal
      ..value += salesItem.subTotal!
      ..value = salesSubTotal.value.toPrecision(2);

    // Add salesItem to salesItemList
    salesItemList.value.add(salesItem);

    // Reset fields after item is added
    resetAfterItemAdd();

    print('salesItem.subTotal: ${salesItem.subTotal}');
  }

  @override
  Future<void> onQtyChange(
    num value,
    int index,
  ) async {
    salesItemList.value[index].quantity = value;
    final item = salesItemList.value[index];

    if (purchaseMode == 'purchase_with_mrp') {
    } else if (purchaseMode == 'purchase_price') {
    } else if (purchaseMode == 'item_percent') {
    } else if (purchaseMode == 'total_price') {}

    calculateAllSubtotal();
  }

  void goToListPage() {}

  Future<void> onSave() async {
    if (salesItemList.value.isEmpty) {
      toast('please_select_item'.tr);
      return;
    }

    final result = await Get.dialog(
      SalesProcessModalView(
        salesItemList: salesItemList.value,
        preSales: preSales,
      ),
    );
    if (result != null) {
      salesItemList.value = result;
      calculateAllSubtotal();
    }
  }
}

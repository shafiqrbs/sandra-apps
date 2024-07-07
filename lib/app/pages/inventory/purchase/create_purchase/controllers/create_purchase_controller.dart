import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
    final stockQty = double.tryParse(
          stockQtyController.value.text,
        ) ??
        0.0;
    final stockMrp = double.tryParse(
          stockMrpController.value.text,
        ) ??
        stock.salesPrice ??
        0.0;
    final discountPercent = double.tryParse(
          stockDiscountPercentController.value.text,
        ) ??
        0.0;

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

    if (process == 'inline') {
      if (purchaseMode == 'purchase_with_mrp') {
        salesItem.subTotal = stockQty * (stock.salesPrice ?? 0.0);
      }
      if (purchaseMode == 'purchase_price' ||
          purchaseMode == 'item_percent' ||
          purchaseMode == 'total_price') {
        salesItem.subTotal = stockQty * (stock.purchasePrice ?? 0.0);
      }
    } else {
      if (purchaseMode == 'purchase_with_mrp') {
        salesItem.subTotal = stockQty * (stock.salesPrice ?? 0.0);
      }
      if (purchaseMode == 'purchase_price') {
        salesItem.subTotal = stockQty * (stock.purchasePrice ?? 0.0);
      }
      if (purchaseMode == 'item_percent') {
        salesItem.subTotal =
            (stockMrp - ((stockMrp * discountPercent) / 100)) * stockQty;
      }
    }
    // Update salesItem with calculated values

    if (salesItem.subTotal == null) {
      toast('sub_total_error'.tr);
      return;
    }

    // Update salesSubTotal value
    salesSubTotal
      ..value += salesItem.subTotal!
      ..value = salesSubTotal.value.toPrecision(2);

    salesItemList.value.add(salesItem);

    resetAfterItemAdd();

    print('salesItem.subTotal: ${salesItem.subTotal}');
  }

  void goToListPage() {}
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}

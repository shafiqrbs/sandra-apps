import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';
import '/app/entity/stock.dart';

abstract class StockSelectionController extends BaseController {
  final stockList = Rx<List<Stock>>([]);
  final selectedStock = Rx<Stock?>(null);
  final stockSearchController = TextEditingController().obs;
  final qtyFocusNode = FocusNode().obs;

  final stockMrpController = TextEditingController().obs;
  final stockQtyController = TextEditingController().obs;
  final stockDiscountController = TextEditingController().obs;
  final stockTotalController = TextEditingController().obs;
  final stockDiscountPercentController = TextEditingController().obs;
  final searchController = TextEditingController().obs;


  Future<void> getStocks(
    String? pattern,
  ) async {
    stockSearchController.refresh();
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

  void resetAfterItemAdd() {
    selectedStock.value = null;
    searchController.value.clear();
    stockMrpController.value.clear();
    stockQtyController.value.clear();
    stockDiscountPercentController.value.clear();
    stockList.value = [];
  }

  Future<void> onClearSearchField() async {
    selectedStock.value = null;
    searchController.value.clear();
    searchController.refresh();
    stockList
      ..value = []
      ..refresh();
  }
}

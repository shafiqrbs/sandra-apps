import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/entity/brand.dart';
import '/app/core/base/base_controller.dart';
import '/app/entity/stock.dart';

abstract class StockSelectionController extends BaseController {
  final stockList = Rx<List<Stock>>([]);
  final selectedStock = Rx<Stock?>(null);
  final qtyFocusNode = FocusNode().obs;

  final stockMrpController = TextEditingController().obs;
  final stockQtyController = TextEditingController().obs;
  final stockDiscountController = TextEditingController().obs;
  final stockTotalController = TextEditingController().obs;
  final stockDiscountPercentController = TextEditingController().obs;
  final searchController = TextEditingController().obs;

  final qtyControllerList = <TextEditingController>[].obs;

  final isShowAddStockButton = false.obs;
  final isShowBrand = false.obs;
  final isShowBrandClearIcon = false.obs;
  final brandManager = BrandManager();

  Future<void> getStocks(
    String? pattern,
  ) async {
    selectedStock.value = null;

    if (pattern == null || pattern.isEmpty) {
      stockList.value = [];
      return;
    }

    String query = "name LIKE '%$pattern%' ";
    if (isShowBrand.value && brandManager.ddController.value != null) {
      query =
          "${query}AND brand_name LIKE '%${brandManager.ddController.value?.name}%'";
    }

    print("Query: $query");

    final stocks = await dbHelper.getAllWhr(
      tbl: dbTables.tableStocks,
      where: query,
      whereArgs: [],
      limit: 100,
    );

    stockList
      ..value = stocks.map(Stock.fromJson).toList()
      ..refresh();
    qtyControllerList.value = List.generate(
      stockList.value.length,
      (index) => TextEditingController(),
    ).obs;
    update();
    notifyChildrens();
    refresh();
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

  Future<void> onBrandSelection(Brand? brand) async {
    // print("Brand: ${brand?.toJson()}");
    if (brand == null) {
      isShowBrandClearIcon.value = false;
    } else {
      isShowBrandClearIcon.value = true;
    }
    brandManager.ddController.value = brand;

    await getStocks(searchController.value.text);
  }
}

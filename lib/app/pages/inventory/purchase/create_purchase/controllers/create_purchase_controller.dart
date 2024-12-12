import 'package:sandra/app/core/importer.dart';

import '/app/core/abstract_controller/stock_selection_controller.dart';
import '/app/entity/purchase.dart';
import '/app/entity/purchase_item.dart';
import '/app/entity/stock.dart';
import '/app/pages/inventory/purchase/create_purchase/modals/purchase_process_modal/purchase_process_view.dart';

class CreatePurchaseController extends StockSelectionController {
  Purchase? prePurchase;
  String? purchaseMode;
  final purchaseItemList = Rx<List<PurchaseItem>>([]);
  final priceController = TextEditingController().obs;
  final totalPriceController = TextEditingController().obs;
  final selectedPurchase = ''.obs;

  //int
  final purchaseSubTotal = 0.00.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    purchaseMode = await prefs.getPurchaseConfig();
    selectedPurchase.value = await prefs.getPurchaseConfig();
    isShowBrand.value = await prefs.getIsShowBrandOnPurchase();

    if (isShowBrand.value) {
      await brandManager.getAll();
    }

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.isNotEmpty) {
      if (args['purchase'] != null && args['purchase'] is Purchase) {
        setData(args['purchase'] as Purchase);
      }
      if (args['purchase_item_list'] != null) {
        if (args['purchase_item_list'] is List<PurchaseItem>) {
          purchaseItemList.value =
              args['purchase_item_list'] as List<PurchaseItem>;
          calculateAllSubtotal();
        }
      }
    } else {
      final itemCount = await dbHelper.getItemCount(
        tableName: dbTables.tablePurchaseItem,
        limit: 1,
      );
      if (itemCount > 0) {
        final purchaseItem = await dbHelper.getAll(
          tbl: dbTables.tablePurchaseItem,
        );
        purchaseItemList.value = purchaseItem
            .map(
              (e) => PurchaseItem.fromJson(e),
            )
            .toList();
      }
    }
    calculateAllSubtotal();
  }

  void setData(
    Purchase purchase,
  ) {
    prePurchase = purchase;
    purchaseItemList.value = purchase.purchaseItem ?? [];
    calculateAllSubtotal();
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
      toast(appLocalization.pleaseSelectItem);
      return;
    }

    // Extract values from controllers
    final stock = selectedStock.value!;
    final stockQty = double.tryParse(stockQtyController.value.text) ?? 0.0;
    final price = double.tryParse(priceController.value.text) ?? 0.0;

    // Create a new purchaseItem instance
    final purchaseItem = PurchaseItem(
      stockId: stock.itemId,
      stockName: stock.name ?? '',
      quantity: stockQty.toPrecision(2),
      price: price,
      subTotal: stockQty * price,
      brandName: stock.brandName,
    );

    // Handle error if subTotal is null
    if (purchaseItem.subTotal == null) {
      toast(appLocalization.error);
      return;
    }

    purchaseItem.subTotal = double.tryParse(
      purchaseItem.subTotal!.toStringAsFixed(2),
    );

    // Update purchaseSubTotal value
    purchaseSubTotal
      ..value += purchaseItem.subTotal!
      ..value = purchaseSubTotal.value.toPrecision(2);

    // Add stock to purchaseItemList
    purchaseItemList.value.add(purchaseItem);
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: dbTables.tablePurchaseItem,
      dataList: [purchaseItem.toJson()],
    );

    // Reset fields after item is added
    resetAfterItemAdd();
    purchaseItemList.refresh();
  }

  Future<void> onQtyChange(
    num value,
    int index,
  ) async {
    purchaseItemList.value[index].quantity = value;
    purchaseItemList.value[index].subTotal =
        value * purchaseItemList.value[index].price!;

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
  ) async {
    // Get the number of controllers with non-empty text
    final nonEmptyControllersCount = qtyControllerList
        .where((controller) => controller.text.isNotEmpty)
        .length;

    // Update the boolean observable value based on whether any controller is non-empty
    isShowAddStockButton.value = nonEmptyControllersCount > 0;

    // If there are non-empty controllers, update the selected stock count
    if (nonEmptyControllersCount > 0) {
      selectedStockCount.value = nonEmptyControllersCount;
    }
  }

  Future<void> onSearchedStockQtyEditComplete(
    num value,
    int index,
  ) async {
    // get all index number of qtyControllerList which is not empty
    final indexList = qtyControllerList
        .asMap()
        .entries
        .where((element) => element.value.text.isNotEmpty)
        .map((e) => e.key)
        .toList();

    final tempStockList = stockList.value;

    for (final i in indexList) {
      final stock = stockList.value[i];
      final qty = double.tryParse(qtyControllerList[i].text) ?? 0.0;
      stockQtyController.value.text = qty.toStringAsFixed(2);
      onStockSelection(stock);
      addPurchaseItem(
        process: 'inline',
      );
      stockList.value = tempStockList;
    }
    stockList.value = [];
    isShowAddStockButton.value = false;
  }

  void goToListPage() {
    Get.offNamed(
      Routes.purchaseList,
    );
  }

  Future<void> onSave() async {
    if (purchaseItemList.value.isEmpty) {
      toast(appLocalization.pleaseSelectItem);
      return;
    }

    final result = await Get.dialog(
      PurchaseProcessView(
        purchaseItemList: purchaseItemList.value,
        prePurchase: prePurchase,
      ),
    );
    if (result != null) {
      purchaseItemList.value = result;
      calculateAllSubtotal();
    }
  }

  Future<void> onItemRemove(
    int index,
  ) async {
    purchaseItemList.value.removeAt(index);
    calculateAllSubtotal();
    purchaseItemList.refresh();
  }

  void onAddStockQtyChange(String? value) {
    if (purchaseMode != 'total_price' || value == null) return;

    final qty = double.tryParse(stockQtyController.value.text) ?? 0.0;
    final price = double.tryParse(priceController.value.text) ?? 0.0;
    totalPriceController.value.text = (qty * price).toStringAsFixed(2);
  }

  void onTotalPriceChange(String? value) {
    if (purchaseMode != 'total_price' || value == null) return;
    final qty = double.tryParse(stockQtyController.value.text) ?? 0.0;
    final totalPrice = double.tryParse(totalPriceController.value.text) ?? 0.0;
    priceController.value.text = (totalPrice / qty).toStringAsFixed(2);
  }

  void onPriceChange(num price, int index) {
    purchaseItemList.value[index].price = price;
    purchaseItemList.value[index].subTotal =
        purchaseItemList.value[index].quantity! * price;
  }

  void addStockFromSearchList() {
    // get all index number of qtyControllerList which is not empty
    final indexList = qtyControllerList
        .asMap()
        .entries
        .where((element) => element.value.text.isNotEmpty)
        .map((e) => e.key)
        .toList();

    final tempStockList = stockList.value;

    for (final i in indexList) {
      final stock = stockList.value[i];
      final qty = double.tryParse(qtyControllerList[i].text) ?? 0.0;
      stockQtyController.value.text = qty.toStringAsFixed(2);
      onStockSelection(stock);
      addPurchaseItem(
        process: 'inline',
      );
      stockList.value = tempStockList;
    }
    stockList.value = [];
    isShowAddStockButton.value = false;
  }
}

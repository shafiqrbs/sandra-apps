import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/entity/restaurant/restaurant_table.dart';
import 'package:sandra/app/entity/restaurant/table_invoice.dart';
import 'package:sandra/app/entity/stock.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/views/order_cart_view.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/views/menu_bottom_sheet.dart';
import 'package:sandra/app/service/parser.dart';
import '/app/core/base/base_controller.dart';

enum MenuView {
  list,
  grid,
}

enum BottomStatus {
  order,
  kitchen,
  hold,
  reserved,
  free,
}

class RestaurantHomeController extends BaseController {
  final searchController = TextEditingController();
  final menuView = Rx<MenuView?>(null);
  final bottomStatus = Rx<BottomStatus>(BottomStatus.hold);
  final List<String> menuItems = [
    'Pizza',
    'Burger',
    'Soup',
    'Salad',
    'Set menu',
    'Juice Special',
    'Sandwich',
    'Pasta',
    'Meat',
    'Fruits',
  ];
  final selectedFoodList = <int>[].obs;
  final addSelectedFoodItem = Rx<Map<int, List<Stock>>>(<int, List<Stock>>{});
  final selectedTableIndex = 0.obs;
  final selectedTableId = 0.obs;
  final tableList = Rx<List<RestaurantTable>?>(null);
  final tableStatusList = Rx<List<BottomStatus>>([]);
  final stockList = Rx<List<Stock?>?>(null);
  RxList<TableInvoice> tableInvoiceList = RxList<TableInvoice>([]);

  @override
  Future<void> onInit() async {
    super.onInit();
    await dataFetcher(
      future: () async {
        await getRestaurantTableList();
        await getStockItems();
        await insertTableList();
        selectedTableId.value = tableList.value!.first.id!;
      },
    );
  }

  Future<void> insertTableList() async {
    if (tableInvoiceList.isEmpty) return;
    await dbHelper.insertList(
      tableName: dbTables.tableTableInvoice,
      dataList: tableInvoiceList.map((e) => e.toJson()).toList(),
      deleteBeforeInsert: true,
    );
  }

  Future<void> getRestaurantTableList() async {
    final response = await services.getRestaurantTableList();
    if (response != null) {
      tableList.value = response;
      tableStatusList.value = List.filled(
        tableList.value?.length ?? 0,
        BottomStatus.free,
      );
    }

    tableInvoiceList.clear();

    for (int i = 0; i < tableList.value!.length; i++) {
      tableInvoiceList.add(
        TableInvoice(
          tableId: tableList.value![i].id,
          process: tableStatusList.value[i].name,
          orderBy: '1',
          additionalTable: '0',
          amount: 0.0,
          discountType: '0',
          discount: 0.0,
          totalDiscount: 0.0,
          couponCode: '',
          couponDiscount: 0.0,
          vat: 0.0,
          sd: 0.0,
          subTotal: 0.0,
          total: 0.0,
          tokenNo: '',
          customerId: 0,
        ),
      );
    }
  }

  Future<void> getStockItems() async {
    final response = await services.getStockItems();
    if (response != null) {
      final stockData = await parseList(
        list: response,
        fromJson: Stock.fromJson,
      );
      stockList.value = stockData;
    }
  }

  void changeMenuView() {
    if (menuView.value == MenuView.list) {
      menuView.value = MenuView.grid;
    } else {
      menuView.value = MenuView.list;
    }
  }

  void changeBottomStatus(BottomStatus status) {
    bottomStatus.value = status;
    changeTableStatus(status);
  }

  void selectTable(
    int index,
    RestaurantTable table,
  ) {
    selectedTableIndex.value = index;
    selectedTableId.value = table.id!;
  }

  void changeTableStatus(BottomStatus status) {
    if (tableStatusList.value.isEmpty) return;
    tableStatusList.value[selectedTableIndex.value] = status;
  }

  Future<void> goToOrderCart({
    required BuildContext context,
  }) async {
    final subtotal = calculateTotalAmount(
      addSelectedFoodItem.value[selectedTableId.value] ?? [],
    );

    await dbHelper.updateWhere(
      tbl: dbTables.tableTableInvoice,
      data: {
        'subtotal': subtotal,
      },
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    final tableInvoice = await dbHelper.getAllWhr(
      tbl: dbTables.tableTableInvoice,
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    final tableName = tableList.value!
        .firstWhere((element) => element.id == selectedTableId.value)
        .tableName;

    Get.dialog(
      OrderCartView(),
      arguments: {
        'tableId': selectedTableId.value,
        'tableName': tableName,
        'tableInvoice': tableInvoice,
      },
    );
  }

  void openMenuBottomSheet({
    required BuildContext context,
  }) {
    MenuBottomSheet(
      context: context,
      menuItems: menuItems,
    ).showMenuFromLeft();
  }

  Future<void> selectFoodItem(int index, Stock stock) async {
    addSelectedFoodItem.value.update(
      selectedTableId.value,
      (value) {
        // Check if the stock item already exists in the list
        final existingStock =
            value.firstWhereOrNull((s) => s.itemId == stock.itemId);
        if (existingStock != null) {
          // If it exists, increment the quantity
          existingStock.quantity = existingStock.quantity! + 1;
        } else {
          // If it doesn't exist, add it to the list with a quantity of 1
          stock.quantity = 1;
          value.add(stock);
        }
        return value;
      },
      ifAbsent: () => [
        stock..quantity = 1,
      ],
    );

    /*addSelectedFoodItem.value.update(
      selectedTableId.value,
      (value) {
        value.add(stock);
        return value;
      },
      ifAbsent: () => [
        stock,
      ],
    );*/
    addSelectedFoodItem.refresh();

    print('addSelectedFoodItem: ${addSelectedFoodItem.value}');

    await dbHelper.updateWhere(
      tbl: dbTables.tableTableInvoice,
      data: {
        'items': jsonEncode(addSelectedFoodItem.value[selectedTableId.value]),
      },
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    toast('Item added to the cart');
  }

  // calculate total amount of the selected items
  double calculateTotalAmount(List<Stock> items) {
    double totalAmount = 0;
    for (final Stock item in items) {
      totalAmount += item.salesPrice! * item.quantity!;
    }
    return totalAmount;
  }
}

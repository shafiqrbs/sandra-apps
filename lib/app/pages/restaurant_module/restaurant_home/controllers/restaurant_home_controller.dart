import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/entity/category.dart';
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
  booked,
  free,
}

class RestaurantHomeController extends BaseController {
  final searchController = TextEditingController();
  final menuView = Rx<MenuView?>(null);
  final bottomStatus = Rx<BottomStatus>(BottomStatus.free);
  final menuItems = Rx<List<Category>?>(null);
  final selectedFoodList = <int>[].obs;
  final addSelectedFoodItem = Rx<Map<int, List<Stock>>>(<int, List<Stock>>{});
  final selectedTableIndex = 0.obs;
  final selectedTableId = 0.obs;
  final tableList = Rx<List<RestaurantTable>?>(null);
  final tableStatusList = Rx<List<BottomStatus>>([]);
  final tableStatusTimeList = Rx<List<String>>([]);
  final stockList = Rx<List<Stock?>?>(null);
  final filteredStockList = Rx<List<Stock?>?>(null);
  RxList<TableInvoice> tableInvoiceList = RxList<TableInvoice>([]);
  final isTableEnabled = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isTableEnabled.value = await prefs.getIsisTableEnabled();
    await dataFetcher(
      future: () async {
        await getRestaurantTableList();
        await getStockItems();
        await insertTableList();
        await getCategories();
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
      tableStatusTimeList.value = List.filled(
        tableList.value?.length ?? 0,
        '00:00:00',
      );
    }

    tableInvoiceList.clear();

    for (int i = 0; i < tableList.value!.length; i++) {
      tableInvoiceList.add(
        TableInvoice(
          tableId: tableList.value![i].id,
          process: tableStatusList.value[i].name,
          orderTime: tableStatusTimeList.value[i],
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
      filteredStockList.value = stockData;
    }
  }

  Future<void> getCategories() async {
    final getData = await dbHelper.getAll(
      tbl: dbTables.tableCategories,
    );
    final categories = getData.map((e) => Category.fromJson(e)).toList();
    menuItems.value = categories;
  }

  void changeMenuView() {
    if (menuView.value == MenuView.list) {
      menuView.value = MenuView.grid;
    } else {
      menuView.value = MenuView.list;
    }
  }

  Future<void> changeBottomStatus(BottomStatus status) async {
    bottomStatus.value = status;
    changeTableStatus(status);
  }

  String tableStatusTime(int index) {
    if (tableStatusTimeList.value[index] != '00:00:00') {
      return tableStatusTimeList.value[index];
    }
    return tableStatusList.value[index].name == 'free'
        ? '00:00:00'
        : DateTime.now().toString().split(' ')[1].substring(0, 8);
  }

  Future<void> selectTable(
    int index,
    RestaurantTable table,
  ) async {
    selectedTableIndex.value = index;
    selectedTableId.value = table.id!;
    final getData = await dbHelper.getAllWhr(
      tbl: dbTables.tableTableInvoice,
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );
    final status = getData.first['process'];
    changeBottomStatus(
      BottomStatus.values.firstWhere(
        (e) => e.name == status,
      ),
    );
  }

  Future<void> changeTableStatus(BottomStatus status) async {
    if (tableStatusList.value.isEmpty) return;
    if (status == BottomStatus.free) {
      tableStatusTimeList.value[selectedTableIndex.value] = '00:00:00';
      tableStatusTimeList.refresh();
    }

    await dbHelper.updateWhere(
      tbl: dbTables.tableTableInvoice,
      data: {
        'process': status.name,
        'order_time': tableStatusTimeList.value[selectedTableIndex.value],
      },
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    tableStatusList.value[selectedTableIndex.value] = status;
    tableStatusTimeList.value[selectedTableIndex.value] =
        tableStatusTime(selectedTableIndex.value);
    tableStatusList.refresh();
    tableStatusTimeList.refresh();
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
      menuItems: menuItems.value ?? [],
    ).showMenuFromLeft();
  }

  Future<void> selectFoodItem(Stock stock) async {
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

    addSelectedFoodItem.refresh();

    await dbHelper.updateWhere(
      tbl: dbTables.tableTableInvoice,
      data: {
        'items': jsonEncode(addSelectedFoodItem.value[selectedTableId.value]),
      },
      where: 'table_id = ?',
      whereArgs: [selectedTableId.value],
    );

    toast(
      'Item added to the cart',
      gravity: ToastGravity.TOP,
    );
  }

  Future<void> onSearch(String value) async {
    debouncer.call(
      () async {
        final searchValue = value.toLowerCase();
        final filteredList = stockList.value?.where((stock) {
          return stock?.name?.toLowerCase().contains(searchValue) ?? false;
        }).toList();

        filteredStockList.value = filteredList;
      },
    );
  }

  void allCategory() {
    Get.back();
    filteredStockList.value = stockList.value;
  }

  void filterByCategory(Category category) {
    Get.back();
    final filteredList = stockList.value?.where((stock) {
      return stock?.categoryId == category.categoryId;
    }).toList();

    filteredStockList.value = filteredList;
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final selectedTableIndex = 0.obs;
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
      },
    );
  }

  Future<void> insertTableList() async {
    print('tableInvoiceList: ${tableInvoiceList}');
    if (tableInvoiceList.isEmpty) return;
    await dbHelper.insertList(
      tableName: dbTables.tableTableInvoice,
      dataList: tableInvoiceList.map((e) => e.toJson()).toList(),
      deleteBeforeInsert: false,
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
          items: '',
        ),
      );
    }
  }

  Future<void> getStockItems() async {
    final response = await services.getStockItems();
    print('stock items: $response');
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

  void changeTableStatus(BottomStatus status) {
    if (tableStatusList.value.isEmpty) return;
    tableStatusList.value[selectedTableIndex.value] = status;
  }

  void goToOrderCart({
    required BuildContext context,
  }) {
    Get.dialog(
      OrderCartView(),
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

  void selectFoodItem(int index) {
    if (selectedFoodList.contains(index)) {
      selectedFoodList.remove(index);
    } else {
      selectedFoodList.add(index);
    }
  }
}

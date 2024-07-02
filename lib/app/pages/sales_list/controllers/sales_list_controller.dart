import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/model/customer.dart';
import 'package:getx_template/app/model/sales.dart';
import 'package:getx_template/app/model/tab_bar_items.dart';
import '/app/core/base/base_controller.dart';

class SalesListController extends BaseController {
  final salesManager = SalesManager();
  final selectedIndex = 0.obs;
  List<TabBarItem> tabPages = [
    TabBarItem(
      name: 'Local',
      slug: 'local',
      icon: 'wifi_off',
      view: Container(),
    ),
    TabBarItem(
      name: 'Hold',
      slug: 'hold',
      icon: 'notes',
      view: Container(),
    ),
    TabBarItem(
      name: 'Online',
      slug: 'online',
      icon: 'wifi',
      view: Container(),
    ),
  ];

  Customer? selectedCustomer;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> changeIndex(int index) async {
    salesManager.allItems.value ??= [];

    salesManager.allItems.value?.clear();

    selectedIndex.value = index;

    switch (index) {
      case 0:
        await _loadSalesData('is_hold is null');
      case 1:
        await _loadSalesData('is_hold == 1');
      case 2:
        await _fetchOnlineSalesData();
      default:
        break;
    }

    update();
    notifyChildrens();
    refresh();
  }

  Future<void> _loadSalesData(String whereClause) async {
    final list = await dbHelper.getAllWhr(
      tbl: dbTables.tableSale,
      where: whereClause,
      whereArgs: [],
    );

    final salesList = list.map((e) => Sales.fromJson(e)).toList();
    salesManager.allItems.value = salesList;

    print('Loaded sales data: $salesList');
    salesManager.allItems.refresh();
  }

  Future<void> _fetchOnlineSalesData() async {
    await dataFetcher(
      future: () async {
        final data = await services.getSalesList(
          shouldShowLoader: false,
          startDate: startDate,
          endDate: endDate,
          customerId: selectedCustomer?.customerId?.toString(),
          vendorId: null,
          keyword: searchQuery,
        );
        if (data != null) {
          salesManager.allItems.value = data;
          print('Fetched online sales data: $data');
        }
      },
    );
  }
}

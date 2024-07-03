import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/model/customer.dart';
import '/app/model/sales.dart';
import '/app/model/tab_bar_items.dart';

class SalesListController extends BaseController {
  final salesManager = SalesManager();
  final selectedIndex = 0.obs;
  final isSearchSelected = false.obs;
  final customerManager = CustomerManager();
  final implyLeading = true.obs;
  final Rx<Icon> actionIcon = const Icon(
    TablerIcons.user_search,
    color: Colors.white,
  ).obs;

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

  Future<void> toggleSearchButton() async {
    isSearchSelected.value = !isSearchSelected.value;
    print('isSearchSelected: ${isSearchSelected.value}');

    if (isSearchSelected.value) {
      actionIcon.value = const Icon(
        TablerIcons.x,
        color: Colors.white,
      );
    } else {
      actionIcon.value = const Icon(
        TablerIcons.user_search,
        color: Colors.white,
      );
      if (!isSearchSelected.value) {
        customerManager.searchTextController.value.clear();
        customerManager.searchTextController.refresh();
        await customerManager.getAllItems(
          fillSearchListOnly: false,
        );
      }
    }
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
          startDate: startDate,
          endDate: endDate,
          customerId: selectedCustomer?.customerId?.toString(),
          vendorId: null,
          keyword: searchQuery,
        );
        if (data != null) {
          salesManager.allItems.value = data;
          print('Loaded online sales data len: ${data.length}');
        }
      },
    );
  }

  showSalesInformationModal(BuildContext context, Sales element) {}

  Future<void> showFilterModal({
    required BuildContext context,
  }) async {
    final value = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: GlobalFilterModalView(),
        );
      },
    );

    if (value != null) {
      startDate = value['start_date'];
      endDate = value['end_date'];
      selectedCustomer = value['customer'];
      searchQuery = value['search_keyword'];
      await changeIndex(selectedIndex.value);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/widget/quick_navigation_button.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/customer.dart';
import '/app/entity/sales.dart';
import '/app/entity/tab_bar_items.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/global_modal/sales_information_modal/sales_information_modal_view.dart';
import '/app/routes/app_pages.dart';

class SalesListController extends BaseController {
  final salesManager = SalesManager();
  final selectedIndex = 0.obs;
  final isSearchSelected = false.obs;
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
      localeMethod: () => appLocalization.local,
    ),
    TabBarItem(
      name: 'Online',
      slug: 'online',
      icon: 'wifi',
      view: Container(),
      localeMethod: () => appLocalization.online,
    ),
    TabBarItem(
      name: 'Hold',
      slug: 'hold',
      icon: 'notes',
      view: Container(),
      localeMethod: () => appLocalization.hold,
    ),
  ];

  Customer? selectedCustomer;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();
    await changeIndex(0);
  }

  Future<void> changeIndex(int index) async {
    selectedIndex.value = index;

    salesManager.allItems.refresh();

    switch (index) {
      case 0:
        await _loadSalesData('is_hold is null');
      case 1:
        await _fetchOnlineSalesData();
      case 2:
        await _loadSalesData('is_hold == 1');

      default:
        break;
    }

    update();
    notifyChildrens();
    refresh();
  }

  Future<void> toggleSearchButton() async {
    isSearchSelected.value = !isSearchSelected.value;
  }

  Future<void> _loadSalesData(String whereClause) async {
    final list = await dbHelper.getAllWhr(
      tbl: dbTables.tableSale,
      where: whereClause,
      whereArgs: [],
    );

    final salesList = list.map(Sales.fromJson).toList();
    salesManager.allItems.value = salesList;
    salesManager.allItems.refresh();
  }

  Future<void> _fetchOnlineSalesData() async {
    await dataFetcher(
      future: () async {
        final data = await services.getSalesList(
          startDate: startDate,
          endDate: endDate,
          customerId: selectedCustomer?.customerId?.toString(),
          keyword: searchQuery,
        );
        salesManager.allItems.value = data;
      },
    );
  }

  Future<void> showSalesInformationModal(
    BuildContext context,
    Sales element,
  ) async {
    final result = await Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: SalesInformationModalView(
          sales: element,
          salesMode: tabPages[selectedIndex.value].slug,
        ),
      ),
    );
  }

  Future<void> showFilterModal({
    required BuildContext context,
  }) async {
    final value = await Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: GlobalFilterModalView(),
      ),
    );

    if (value != null && value is Map) {
      startDate = value['start_date'];
      endDate = value['end_date'];
      selectedCustomer = value['customer'];
      searchQuery = value['search_keyword'];
      await changeIndex(selectedIndex.value);
    }
  }

  void goToCreateSales() {
    Get.offNamed(
      Routes.createSales,
    );
  }

  Future<void> onClearSearchText() async {
    salesManager.searchTextController.value.clear();
    salesManager.allItems.value?.clear();
    salesManager.allItems.refresh();
    isSearchSelected.toggle();
    await changeIndex(selectedIndex.value);
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/entity/customer.dart';
import '/app/entity/sales.dart';
import '/app/entity/tab_bar_items.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/pages/inventory/sales/sales_list/modals/sales_information_modal/sales_information_modal_view.dart';
import '/app/routes/app_pages.dart';

enum SalesListPageTabs {
  local,
  online,
  hold,
}

class SalesListController extends BaseController {
  final salesManager = SalesManager();
  final PagingController<int, Sales> pagingController = PagingController(
    firstPageKey: 0,
  );

  final selectedIndex = 100.obs;
  final isSearchSelected = false.obs;

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
  int page = 1;

  @override
  Future<void> onInit() async {
    super.onInit();
    pagingController.addPageRequestListener(
      (pageKey) {
        _fetchOnlineSalesData(
          page: pageKey,
        );
      },
    );

    await changeIndex(0);
  }

  Future<void> changeIndex(int index) async {
    selectedIndex.value = index;
    salesManager.allItems.value = null;
    pagingController.itemList = [];
    salesManager.allItems.refresh();
    page = 1;

    switch (index) {
      case 0:
        await _loadSalesData('is_hold is null');
      case 1:
        await _fetchOnlineSalesData(
          page: page,
        );
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
    pagingController.itemList = [];
    final list = await dbHelper.getAllWhr(
      tbl: dbTables.tableSale,
      where: whereClause,
      whereArgs: [],
    );

    final salesList = list.map(Sales.fromJson).toList();
    salesManager.allItems.value = salesList;
    salesManager.allItems.refresh();
  }

  Future<void> _fetchOnlineSalesData({
    required int page,
  }) async {
    await dataFetcher(
      future: () async {
        final data = await services.getSalesList(
          startDate: startDate,
          endDate: endDate,
          customerId: selectedCustomer?.customerId?.toString(),
          keyword: searchQuery,
          page: page,
        );
        page++;
        if (data?.isNotEmpty ?? false) {
          salesManager.allItems.value = [
            ...salesManager.allItems.value ?? [],
            ...data!,
          ];
          salesManager.allItems.refresh();
          pagingController.appendPage(data, page);
        }
      },
      shouldShowLoader: salesManager.allItems.value == null,
    );

    if (kDebugMode) {
      print('Sales data len ${salesManager.allItems.value?.length}');
      print('Page $page');
    }
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
          onDeleted: () async {
            Get.back();
            toast('Sales deleted successfully');
            await changeIndex(selectedIndex.value);
          },
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

  Future<void> deleteSales({
    required String salesId,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      if (selectedIndex.value == 1) {
        bool? isDeleted;
        await dataFetcher(
          future: () async {
            isDeleted = await services.deleteSales(
              id: salesId,
            );
          },
        );
        if (isDeleted ?? false) {
          selectedIndex.value = 100;
          await changeIndex(1);
        }
      } else {
        await dbHelper.deleteAllWhr(
          tbl: dbTables.tableSale,
          where: 'sales_id = ?',
          whereArgs: [salesId],
        );
        salesManager.allItems.value?.removeWhere(
          (element) => element.salesId == salesId,
        );
        salesManager.allItems.refresh();
        await changeIndex(selectedIndex.value);
      }
    }
  }
}

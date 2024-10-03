import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/page_state.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/entity/customer.dart';
import '/app/entity/sales.dart';
import '/app/entity/tab_bar_items.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/global_modal/sales_information_modal/sales_information_modal_view.dart';
import '/app/routes/app_pages.dart';

enum SalesListPageTabs {
  local,
  online,
  hold,
}

class SalesListController extends BaseController {
  final salesManager = SalesManager();
  final pagingController = Rx<PagingController<int, Sales>>(
    PagingController<int, Sales>(
      firstPageKey: 1,
    ),
  );

  final selectedIndex = 100.obs;
  final isSearchSelected = false.obs;

  final tabPages = [
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
    final isOnline = await prefs.getIsSalesOnline();
    if (isOnline) {
      await changeTab(1);
    } else {
      await changeTab(0);
    }
  }

  Future<void> changeTab(int index) async {
    if (index == selectedIndex.value) {
      showSnackBar(
        type: SnackBarType.warning,
        message: appLocalization.pullForRefresh,
        title: appLocalization.refresh,
      );
      return;
    }

    updatePageState(PageState.loading);

    try {
      selectedIndex.value = index;
      salesManager.allItems.value = null;

      if (selectedIndex.value == 1) {
        //clear paging controller
        pagingController.value = PagingController<int, Sales>(
          firstPageKey: 1,
        );

        //add page request listener
        pagingController.value.addPageRequestListener(
          (pageKey) {
            _fetchOnlineSalesData(
              pageKey: pageKey,
            );
          },
        );

        await _fetchOnlineSalesData(
          pageKey: 1,
        );
      }

      String condition = '';

      if (selectedCustomer != null) {
        condition += ' AND customer_id = ${selectedCustomer!.customerId!}';
      }

      if (startDate != null) {
        // Assuming you want to include the whole day for startDate
        final formattedStartDate = '$startDate 00:00:00';
        condition += " AND created_at >= '$formattedStartDate'";
      }

      if (endDate != null) {
        // Assuming you want to include the whole day for endDate
        final formattedEndDate = '$endDate 23:59:59';
        condition += " AND created_at <= '$formattedEndDate'";
      }

      if (searchQuery != null) {
        condition +=
            " AND (sales_id LIKE '%$searchQuery%' OR customer_name LIKE '%$searchQuery%' OR customer_mobile LIKE '%$searchQuery%')";
      }

      if (selectedIndex.value == 0) {
        await _loadSalesData('is_hold IS NULL $condition');
      }
      if (selectedIndex.value == 2) {
        await _loadSalesData('is_hold = 1 $condition');
      }
    } finally {
      if (salesManager.allItems.value == null &&
          pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
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

  Future<void> _fetchOnlineSalesData({
    required int pageKey,
  }) async {
    List<Sales>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getSalesList(
          customerId: selectedCustomer?.customerId?.toString(),
          startDate: startDate,
          endDate: endDate,
          keyword: searchQuery,
          page: pageKey,
        );
      },
      shouldShowLoader: false,
    );

    if (apiDataList == null) {
      pagingController.value.error = true;
      return;
    }

    if ((apiDataList?.length ?? 0) < pageLimit) {
      pagingController.value.appendLastPage(apiDataList!);
    } else {
      pagingController.value.appendPage(
        apiDataList!,
        pageKey + 1,
      );
    }

    update();
    refresh();
    notifyChildrens();
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
            await refreshData();
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
      await refreshData();
    }
  }

  void goToCreateSales() {
    if (SetUp().mainAppName == 'restaurant') {
      Get.offNamed(
        Routes.restaurantHome,
      );
    } else {
      Get.offNamed(
        Routes.createSales,
      );
    }
  }

  Future<void> onClearSearchText() async {
    salesManager.searchTextController.value.clear();
    isSearchSelected.toggle();
    if (searchQuery != null ||
        selectedCustomer != null ||
        startDate != null ||
        endDate != null) {
      searchQuery = null;
      selectedCustomer = null;
      startDate = null;
      endDate = null;
      await refreshData();
    }
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
          await refreshData();
        }
      } else {
        await dbHelper.deleteAllWhr(
          tbl: dbTables.tableSale,
          where: 'sales_id = ?',
          whereArgs: [salesId],
        );
        //await refreshData();
        final index = salesManager.allItems.value!.indexWhere(
          (element) => element.salesId == salesId,
        );
        if (index != -1) {
          salesManager.allItems.value!.removeAt(index);
          salesManager.allItems.refresh();
        }
      }
    }
  }

  Future<void> refreshData() async {
    final int index = selectedIndex.value;
    selectedIndex.value = 100;
    await changeTab(index);
  }

  Future<void> onSearch(String value) async {
    debouncer.call(
      () async {
        searchQuery = value;
        refreshData();
      },
    );
  }

  Future<void> syncSales() async {
    final salesList = await dbHelper.getAllWhr(
      tbl: dbTables.tableSale,
      where: 'is_hold is null or is_hold == 0',
      whereArgs: [],
    );

    if (salesList.isEmpty) {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.noDataFound,
        title: appLocalization.error,
      );
      return;
    }
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) {
      return;
    }

    bool? isSalesSynced;

    await dataFetcher(
      future: () async {
        isSalesSynced = await services.postSales(
          salesList: salesList,
          mode: 'offline',
        );
      },
    );

    if (isSalesSynced ?? false) {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tableSale,
        where: 'is_hold is null or is_hold == 0',
        whereArgs: [],
      );
      await refreshData();
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.yourDataHasBeenSynced,
      );
    }
  }
}

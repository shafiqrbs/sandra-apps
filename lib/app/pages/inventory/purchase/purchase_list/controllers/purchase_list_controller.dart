import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/page_state.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/entity/purchase.dart';
import '/app/entity/tab_bar_items.dart';
import '/app/entity/vendor.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/global_modal/purchase_information_modal/purchase_information_view.dart';
import '/app/routes/app_pages.dart';

class PurchaseListController extends BaseController {
  final purchaseManager = PurchaseManager();
  final pagingController = Rx<PagingController<int, Purchase>>(
    PagingController<int, Purchase>(
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

  Vendor? selectedCustomer;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();
    await changeTab(0);
  }

  Future<void> changeTab(int index) async {
    if (index == selectedIndex.value) {
      showSnackBar(
        message: appLocalization.pullForRefresh,
        title: appLocalization.refresh,
      );
      return;
    }

    updatePageState(PageState.loading);

    try {
      selectedIndex.value = index;
      purchaseManager.allItems.value = null;

      if (selectedIndex.value == 1) {
        //clear paging controller
        pagingController.value = PagingController<int, Purchase>(
          firstPageKey: 1,
        );

        //add page request listener
        pagingController.value.addPageRequestListener(
          (pageKey) {
            _fetchOnlinePurchaseData(
              pageKey: pageKey,
            );
          },
        );

        await _fetchOnlinePurchaseData(
          pageKey: 1,
        );
      }

      String condition = '';

      if (selectedCustomer != null) {
        condition += ' AND customer_id = ${selectedCustomer!.vendorId!}';
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
            " AND (purchase_id LIKE '%$searchQuery%' OR customer_name LIKE '%$searchQuery%' OR customer_mobile LIKE '%$searchQuery%')";
      }

      if (selectedIndex.value == 0) {
        await _loadPurchaseData('is_hold IS NULL $condition');
      }
      if (selectedIndex.value == 2) {
        await _loadPurchaseData('is_hold = 1 $condition');
      }
    } finally {
      if (purchaseManager.allItems.value == null &&
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

  Future<void> _loadPurchaseData(String whereClause) async {
    final list = await dbHelper.getAllWhr(
      tbl: dbTables.tablePurchase,
      where: whereClause,
      whereArgs: [],
    );

    final purchaseList = list.map(Purchase.fromJson).toList();
    purchaseManager.allItems.value = purchaseList;
    purchaseManager.allItems.refresh();
  }

  Future<void> _fetchOnlinePurchaseData({
    required int pageKey,
  }) async {
    List<Purchase>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getPurchaseList(
          vendorId: selectedCustomer?.vendorId?.toString(),
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

  Future<void> showPurchaseInformationModal(
    BuildContext context,
    Purchase element,
  ) async {
    final result = await Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: PurchaseInformationView(
          purchase: element,
          purchaseMode: tabPages[selectedIndex.value].slug,
          onDeleted: () async {
            Get.back();
            toast('Purchase deleted successfully');
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
        title: appLocalization.purchaseOrder,
        subTitle: 'subTitle',
        child: GlobalFilterModalView(
          showCustomer: false,
          showVendor: true,
        ),
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

  void goToCreatePurchase() {
    Get.offNamed(
      Routes.createPurchase,
    );
  }

  Future<void> onClearSearchText() async {
    purchaseManager.searchTextController.value.clear();
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

  Future<void> deletePurchase({
    required String purchaseId,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      if (selectedIndex.value == 1) {
        bool? isDeleted;
        await dataFetcher(
          future: () async {
            isDeleted = await services.deletePurchase(
              id: purchaseId,
            );
          },
        );
        if (isDeleted ?? false) {
          await refreshData();
        }
      } else {
        await dbHelper.deleteAllWhr(
          tbl: dbTables.tablePurchase,
          where: 'purchase_id = ?',
          whereArgs: [purchaseId],
        );
        //await refreshData();
        final index = purchaseManager.allItems.value!.indexWhere(
          (element) => element.purchaseId == purchaseId,
        );
        if (index != -1) {
          purchaseManager.allItems.value!.removeAt(index);
          purchaseManager.allItems.refresh();
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
}

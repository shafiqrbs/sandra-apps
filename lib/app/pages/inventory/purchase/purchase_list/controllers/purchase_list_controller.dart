import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/entity/purchase.dart';
import '/app/entity/tab_bar_items.dart';
import '/app/entity/vendor.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/pages/inventory/purchase/purchase_list/modals/purchase_information_modal/purchase_information_view.dart';
import '/app/routes/app_pages.dart';

class PurchaseListController extends BaseController {
  final purchaseManager = PurchaseManager();
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

  Vendor? selectedVendor;
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
    purchaseManager.allItems.value = null;
    purchaseManager.allItems.refresh();

    switch (index) {
      case 0:
        await _loadPurchaseData('is_hold is null');
      case 1:
        await _fetchOnlinePurchaseData();
      case 2:
        await _loadPurchaseData('is_hold == 1');

      default:
        break;
    }

    update();
    notifyChildrens();
    refresh();
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

  Future<void> _fetchOnlinePurchaseData() async {
    await dataFetcher(
      future: () async {
        final data = await services.getPurchaseList(
          startDate: startDate,
          endDate: endDate,
          vendorId: selectedVendor?.vendorId?.toString(),
          keyword: searchQuery,
        );
        if (data != null) {
          purchaseManager.allItems.value = data;
        }
      },
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
      selectedVendor = value['customer'];
      searchQuery = value['search_keyword'];
      await changeIndex(selectedIndex.value);
    }
  }

  void goToCreatePurchase() {
    Get.offNamed(
      Routes.createPurchase,
    );
  }

  Future<void> showPurchaseInformationModal(
    BuildContext context,
    Purchase element,
  ) async {
    final result = Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: PurchaseInformationView(
          purchase: element,
          purchaseMode: tabPages[selectedIndex.value].slug,
        ),
      ),
    );
  }

  Future<void> onClearSearchText() async {
    purchaseManager.searchTextController.value.clear();
    purchaseManager.allItems.value?.clear();
    purchaseManager.allItems.refresh();
    isSearchSelected.toggle();
    await changeIndex(selectedIndex.value);
  }
}

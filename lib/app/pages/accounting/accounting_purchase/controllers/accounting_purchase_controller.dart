import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/entity/purchase.dart';
import 'package:sandra/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import 'package:sandra/app/pages/inventory/purchase/purchase_list/modals/purchase_information_modal/purchase_information_view.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/vendor.dart';
import '/app/entity/vendor_ledger.dart';
import '/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';

class AccountingPurchaseController extends BaseController {
  final searchTextController = TextEditingController().obs;
  final pagingController = Rx<PagingController<int, VendorLedger>>(
    PagingController<int, VendorLedger>(
      firstPageKey: 1,
    ),
  );
  final isSearchSelected = false.obs;

  Vendor? selectedVendor;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();

    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchPurchaseList(
          pageKey: pageKey,
        );
      },
    );
    try {
      updatePageState(PageState.loading);
      await fetchPurchaseList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

  Future<void> fetchPurchaseList({
    required int pageKey,
  }) async {
    List<VendorLedger>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getAccountPurchaseList(
          vendorId: selectedVendor?.vendorId?.toString(),
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

  Future<void> onClearSearchText() async {
    searchTextController.value.clear();
    isSearchSelected.value = false;
    if (searchQuery != null ||
        selectedVendor != null ||
        startDate != null ||
        endDate != null) {
      searchQuery = null;
      selectedVendor = null;
      startDate = null;
      endDate = null;
      await refreshData();
    }
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
      await refreshData();
    }
  }

  void goToCreatePurchase() {}

  Future<void> showPurchaseInformationModal(
    BuildContext context,
    VendorLedger element,
  ) async {
    if (element.sourceInvoice != null) {
      final invoice = Purchase(
        purchaseId: element.sourceInvoice.toString(),
      );
      await Get.dialog(
        DialogPattern(
          title: appLocalization.purchaseDetails,
          subTitle: element.name ?? '',
          child: PurchaseInformationView(
            purchase: invoice,
            purchaseMode: 'online',
            isShowFooter: false,
          ),
        ),
      );
    }
  }

  Future<void> showVendorPaymentModal() async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.newReceive,
        subTitle: '',
        child: VendorPaymentModalView(
          vendor: null,
        ),
      ),
    );
    if (isNewReceived == true) {
      await refreshData();
    }
  }

  Future<void> deletePurchase(int purchaseId) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isDeleted;
      await dataFetcher(
        future: () async {
          isDeleted = await services.deleteAccountPurchase(
            id: purchaseId.toString(),
          );
        },
      );
      if (isDeleted ?? false) {
        await refreshData();
      }
    }
  }

  Future<void> approvePurchase({
    required int purchaseId,
    required int index,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isApproved;
      await dataFetcher(
        future: () async {
          isApproved = await services.approveAccountPurchase(
            id: purchaseId.toString(),
          );
        },
      );
      if (isApproved ?? false) {
        await refreshData();
      }
    }
  }

  Future<void> onSearch(String value) async {
    debouncer.call(
      () async {
        searchQuery = value;
        refreshData();
      },
    );
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchPurchaseList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }
}

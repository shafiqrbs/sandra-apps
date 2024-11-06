import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/pdf_views/sales_purchase_pdf_function.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/vendor.dart';
import '/app/entity/vendor_ledger.dart';
import '/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';

class VendorLedgerController extends BaseController {
  Vendor? vendor;

  final vendorManager = VendorManager();
  final pagingController = Rx<PagingController<int, VendorLedger>>(
    PagingController<int, VendorLedger>(
      firstPageKey: 1,
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      vendor = args['vendor'];
      vendorManager.selectedItem.value = vendor;
    }

    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchLedgerReport(
          pageKey: pageKey,
        );
      },
    );
    try {
      updatePageState(PageState.loading);
      await fetchLedgerReport(
        pageKey: 1,
      );
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

  Future<void> fetchLedgerReport({
    required int pageKey,
  }) async {
    List<VendorLedger>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getVendorLedgerReport(
          vendorId: vendor!.vendorId.toString(),
          pageKey: pageKey,
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

  Future<void> updateVendor(Vendor data) async {
    // Clear the selected item and search results
    vendorManager.selectedItem.value = null;
    vendorManager.searchedItems.value = null;

    // Update the search text controller with the customer's name
    vendorManager.searchTextController.value.text = data.name ?? '';

    // Set the selected item to the new customer data
    vendorManager.selectedItem.value = data;

    // Refresh the selected item to notify listeners
    vendorManager.selectedItem.refresh();

    vendor = data;
    await refreshData();

    // Unfocus the current focus scope to hide the keyboard
    FocusScope.of(Get.context!).unfocus();

    // Update the state and notify children widgets
    update();
    notifyChildrens();
    refresh();
  }

  void clearSearch() {
    vendorManager.searchTextController.value.clear();
    vendorManager.searchedItems.value = null;
    vendorManager.searchTextController.refresh();
  }

  Future<void> startVoiceSearch() async {
    if (!voiceRecognition.isListening) {
      await voiceRecognition.startListening(
        (result) {
          vendorManager.searchTextController.value.text = result;
          vendorManager.searchItemsByName(result);
        },
      );
    } else {
      await voiceRecognition.stopListening();
    }
  }

  void searchCustomer(String value) {
    vendorManager.searchItemsByName(value);
    vendorManager.searchTextController.refresh();
  }

  void showReceiveModal() {
    Get.dialog(
      DialogPattern(
        title: appLocalization.payment,
        subTitle: '',
        child: VendorPaymentModalView(
          vendor: vendor,
        ),
      ),
    );
  }

  Future<void> createLedgerPdf({
    required List<VendorLedger> vendorLedgerReport,
    required Vendor vendor,
  }) async {
    await generateVendorLedgerPdf(
      ledger: vendorLedgerReport,
      vendor: vendor,
    );
  }

  Future<void> printVendorLedger({
    required List<VendorLedger> vendorLedgerReport,
    required Vendor vendor,
  }) async {
    PrinterController().printVendorLedger(
      ledger: vendorLedgerReport,
      vendor: vendor,
    );
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchLedgerReport(
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

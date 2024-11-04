import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/pdf_views/sales_purchase_pdf_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/vendor.dart';
import '/app/entity/vendor_ledger.dart';
import '/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';
import '/app/core/base/base_controller.dart';

class VendorLedgerController extends BaseController {
  Vendor? vendor;

  final vendorLedgerList = Rx<List<VendorLedger>?>(null);
  final vendorManager = VendorManager();

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      vendor = args['vendor'];
      vendorManager.selectedItem.value = vendor;
    }

    await fetchLedgerReport();
  }

  Future<void> fetchLedgerReport() async {
    await dataFetcher(
      future: () async {
        vendorLedgerList.value = await services.getVendorLedgerReport(
          vendorId: vendor!.vendorId.toString(),
        );
      },
    );
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

    await fetchLedgerReport();

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
}

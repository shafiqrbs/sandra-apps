import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';

class CustomerLedgerController extends BaseController {
  Customer? customer;

  final customerLedgerReport = Rx<List<CustomerLedger>?>(null);

  final customerManager = CustomerManager();

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      customer = args['customer'];
      customerManager.selectedItem.value = customer;
    }

    await fetchLedgerReport();
  }

  Future<void> fetchLedgerReport() async {
    await dataFetcher(
      future: () async {
        customerLedgerReport.value = await services.getCustomerLedgerReport(
          customerId: customer!.customerId.toString(),
        );
      },
    );
  }

  Future<void> updateCustomer(Customer data) async {
    // Clear the selected item and search results
    customerManager.selectedItem.value = null;
    customerManager.searchedItems.value = null;

    // Update the search text controller with the customer's name
    customerManager.searchTextController.value.text = data.name ?? '';

    // Set the selected item to the new customer data
    customerManager.selectedItem.value = data;

    // Refresh the selected item to notify listeners
    customerManager.selectedItem.refresh();

    await fetchLedgerReport();

    // Unfocus the current focus scope to hide the keyboard
    FocusScope.of(Get.context!).unfocus();

    // Update the state and notify children widgets
    update();
    notifyChildrens();
    refresh();
  }

  void clearSearch() {
    customerManager.searchTextController.value.clear();
    customerManager.searchedItems.value = null;
    customerManager.searchTextController.refresh();
  }

  Future<void> startVoiceSearch() async {
    if (!voiceRecognition.isListening) {
      await voiceRecognition.startListening(
        (result) {
          customerManager.searchTextController.value.text = result;
          customerManager.searchItemsByName(result);
        },
      );
    } else {
      await voiceRecognition.stopListening();
    }
  }

  void searchCustomer(String value) {
    customerManager.searchItemsByName(value);
    customerManager.searchTextController.refresh();
  }

  void showReceiveModal() {
    Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: CustomerReceiveModalView(
          customer: customer,
        ),
      ),
    );
  }
}

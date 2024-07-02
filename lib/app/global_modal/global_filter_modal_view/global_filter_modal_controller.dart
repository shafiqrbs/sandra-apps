import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '/app/core/base/base_controller.dart';
import '/app/model/customer.dart';

class GlobalFilterModalController extends BaseController {
  final startDateController = TextEditingController().obs;
  final endDateController = TextEditingController().obs;
  final searchKeyword = TextEditingController().obs;
  final customerManager = CustomerManager();

  void onClose() {
    Get.back();
  }

  void onSubmit() {
    Get.back(
      result: {
        'start_date': startDateController.value.text,
        'end_date': endDateController.value.text,
        'customer': customerManager.selectedItem.value,
        'search_keyword': searchKeyword.value.text,
      },
    );
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
    }
  }

  Future<void> onCustomerSearch(String? value) async {
    if (value?.isEmpty ?? true) {
      customerManager.searchedItems.value = [];
      customerManager.selectedItem.value = null;
      return;
    }
    await customerManager.searchItemsByName(value!);
  }
}

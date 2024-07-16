import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_controller.dart';
import '/app/entity/transaction_methods.dart';
import '/app/entity/vendor.dart';

import '/app/core/abstract_controller/payment_gateway_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/entity/customer.dart';

class VendorPaymentModalController extends BaseController {
  final vendorManager = VendorManager();
  final transactionMethodsManager = TransactionMethodsManager();
  final amountController = TextEditingController().obs;
  final addRemarkController = TextEditingController().obs;
  final selectedPaymentMode = 'cash'.obs;

  VendorPaymentModalController({
    Vendor? vendor,
  }) {
    vendorManager.selectedItem.value = vendor;
  }
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> resetField() async {
    transactionMethodsManager.asController.selectedValue = null;
    amountController.value.clear();
    addRemarkController.value.clear();
    update();
    notifyChildrens();
    refresh();
  }

  Future<void> processReceive() async {
    if (amountController.value.text.isEmpty) {
      toast('please_enter_amount'.tr);
      return;
    }
    if (vendorManager.selectedItem.value == null) {
      toast('please_select_customer'.tr);
      return;
    }

    await dataFetcher(
      future: () async {
        final data = await services.postVendorPayment(
          shouldShowLoader: true,
          vendor: vendorManager.selectedItem.value!.vendorId!.toString(),
          method: 'receive',
          mode: selectedPaymentMode.value,
          amount: amountController.value.text,
          userId: LoggedUser().userId.toString(),
          remark: addRemarkController.value.text,
        );
        log('Receive Success $data');
      },
    );
  }

  Future<void> updateCustomer(Vendor? vendor) async {
    if (vendor != null) {
      vendorManager.searchTextController.value.text = vendor.name!;
      vendorManager.searchedItems.value = null;
      vendorManager.selectedItem.value = vendor;
    }
  }

  Future<void> onSearchCustomer(String? value) async {
    if (value?.isEmpty ?? true) {
      vendorManager.searchedItems.value = [];
      vendorManager.selectedItem.value = null;
      return;
    }
    await vendorManager.searchItemsByName(value!);
  }
}
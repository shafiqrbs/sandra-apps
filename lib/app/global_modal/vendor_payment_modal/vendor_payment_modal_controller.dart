import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/transaction_methods.dart';
import '/app/entity/vendor.dart';
import '/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';

class VendorPaymentModalController extends BaseController {
  final vendorManager = VendorManager();
  final transactionMethodsManager = TransactionMethodsManager();
  final amountController = TextEditingController().obs;
  final addRemarkController = TextEditingController().obs;
  final selectedPaymentMode = 'cash'.obs;
  final isShowClearIcon = false.obs;

  VendorPaymentModalController({
    Vendor? vendor,
  }) {
    vendorManager.selectedItem.value = vendor;
  }
  @override
  Future<void> onInit() async {
    super.onInit();
    await transactionMethodsManager.getAll();
    transactionMethodsManager.selectedItem.value = transactionMethodsManager
        .allItems.value
        ?.where((element) => element.isDefault == 1)
        .first;
  }

  Future<void> resetField() async {
    transactionMethodsManager.asController.selectedValue = null;
    transactionMethodsManager.allItems.value = null;
    amountController.value.clear();
    addRemarkController.value.clear();
    update();
    notifyChildrens();
    refresh();
  }

  Future<void> processReceive() async {
    final List<String> errors = [];

    if (amountController.value.text.isEmpty) {
      errors.add(appLocalization.enterAmount);
    }
    if (vendorManager.selectedItem.value == null) {
      errors.add(appLocalization.selectVendor);
    }

    if (errors.isNotEmpty) {
      final String numberedErrors = errors
          .asMap()
          .entries
          .map((entry) => "${entry.key + 1}. ${entry.value}")
          .join('\n');

      showSnackBar(
        type: SnackBarType.error,
        message: numberedErrors,
      );
      return;
    }

    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (!confirmation) return;

    bool? isSubmitted;

    await dataFetcher(
      future: () async {
        isSubmitted = await services.postVendorPayment(
          vendor: vendorManager.selectedItem.value!.vendorId!.toString(),
          method: 'receive',
          mode: selectedPaymentMode.value,
          amount: amountController.value.text,
          userId: LoggedUser().userId.toString(),
          remark: addRemarkController.value.text,
        );
      },
    );
    if (isSubmitted ?? false) {
      await resetField();
      Get.back(
        result: true,
      );
    }
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

  Future<void> addVendor() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.addVendor,
        subTitle: '',
        child: AddVendorModalView(),
      ),
    ) as Vendor?;

    if (result != null) {
      vendorManager.selectedItem.value = result;
      vendorManager.searchTextController.value.text = result.name!;
      vendorManager.searchedItems.value = null;
      update();
      notifyChildrens();
      refresh();
    }
  }
}

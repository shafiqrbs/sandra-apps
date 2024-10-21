import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/add_customer_modal/add_customer_modal_view.dart';

import '/app/core/abstract_controller/payment_gateway_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/entity/customer.dart';

class CustomerReceiveModalController extends PaymentGatewayController {
  CustomerReceiveModalController({
    Customer? customer,
  }) {
    customerManager.selectedItem.value = customer;
  }
  @override
  Future<void> onInit() async {
    super.onInit();
    await baseInit();
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
    final List<String> errors = [];

    if (customerManager.selectedItem.value == null) {
      errors.add(appLocalization.pleaseSelectCustomer);
    }

    if (transactionMethodsManager.selectedItem.value == null) {
      errors.add(appLocalization.pleaseSelectPaymentMethod);
    }

    if (amountController.value.text.isEmpty) {
      errors.add(appLocalization.pleaseEnterAmount);
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
        isSubmitted = await services.postCustomerReceive(
          customer: customerManager.selectedItem.value!.customerId!.toString(),
          method:  transactionMethodsManager.selectedItem.value!.methodId!
              .toString(),
          mode:'Due',
          amount: amountController.value.text,
          userId: LoggedUser().userId.toString(),
          remark: addRemarkController.value.text,
          isSms: isSms.value ? '1' : '0',
        );
      },
    );
    if (isSubmitted ?? false) {
      await resetField();
      Get.back(
        result: true,
      );
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.receiveAddedSuccessfully,
      );
    }
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
    }
  }

  Future<void> onSearchCustomer(String? value) async {
    if (value?.isEmpty ?? true) {
      customerManager.searchedItems.value = [];
      customerManager.selectedItem.value = null;
      return;
    }
    await customerManager.searchItemsByName(value!);
  }

  Future<void> addCustomer() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.addCustomer,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
    ) as Customer?;

    if (result != null) {
      customerManager.selectedItem.value = result;
      customerManager.searchTextController.value.text = result.name!;
      customerManager.searchedItems.value = null;
      update();
      notifyChildrens();
      refresh();
    }
  }
}

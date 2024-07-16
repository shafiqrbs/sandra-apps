import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

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
    if (amountController.value.text.isEmpty) {
      toast('please_enter_amount'.tr);
      return;
    }
    if (customerManager.selectedItem.value == null) {
      toast('please_select_customer'.tr);
      return;
    }

    await dataFetcher(
      future: () async {
        final data = await services.postReceive(
          shouldShowLoader: true,
          customer: customerManager.selectedItem.value!.customerId!.toString(),
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
}

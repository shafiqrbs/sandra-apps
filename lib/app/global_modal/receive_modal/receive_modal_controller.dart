import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';


class ReceiveModalController extends PaymentGatewayController {
  ReceiveModalController({
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

    await newServices.fetchOnlineData(
      () async {
        final data = await newServices.postReceive(
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
}

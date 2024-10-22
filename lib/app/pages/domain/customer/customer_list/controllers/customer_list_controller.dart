import 'package:get/get.dart';
import 'package:sandra/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import 'package:sandra/app/routes/app_pages.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import '/app/entity/customer.dart';
import '/app/core/base/base_controller.dart';

class CustomerListController extends BaseController {
  final customerManager = CustomerManager();
  final isSearchSelected = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await customerManager.paginate();
  }

  void showAddCustomerModal() {
    final result = Get.dialog(
      DialogPattern(
        title: appLocalization.newCustomer,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
    );
  }

  Future<void> onClearSearchText() async {
    customerManager.searchTextController.value.clear();
    customerManager.allItems.value?.clear();
    customerManager.allItems.refresh();
    isSearchSelected.value = false;
    await customerManager.paginate();
  }

  Future<void> showCustomerReceiveModal(Customer? element) async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.salesReceive,
        subTitle: '',
        child: CustomerReceiveModalView(
          customer: element,
        ),
      ),
    );
    if (isNewReceived != null && isNewReceived) {
      Get.offNamed(
        Routes.accountingSales,
      );
    }
  }
}

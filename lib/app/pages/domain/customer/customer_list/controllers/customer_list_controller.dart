import 'package:get/get.dart';
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
}

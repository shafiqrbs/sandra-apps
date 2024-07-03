import 'package:get/get.dart';
import 'package:getx_template/app/model/customer.dart';
import '/app/core/base/base_controller.dart';

class CustomerListController extends BaseController {
  final customerManager = CustomerManager();
  final isSearchSelected = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await customerManager.paginate();
  }

  void showAddCustomerModal() {}

  Future<void> onClearSearchText() async {
    customerManager.searchTextController.value.clear();
    isSearchSelected.value = false;
    await customerManager.paginate();
  }
}

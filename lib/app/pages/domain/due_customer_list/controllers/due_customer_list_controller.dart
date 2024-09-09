import 'package:get/get.dart';
import '/app/core/db_helper/db_tables.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/customer.dart';
import '/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import '/app/core/base/base_controller.dart';

class DueCustomerListController extends BaseController {
  final customerManager = CustomerManager();
  final dataList = Rx<List<Customer>?>(null);
  final isSearchSelected = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getDueCustomerList();
    //await customerManager.paginate();
  }

  Future<void> getDueCustomerList() async {
    final data =await dbHelper.getAllWhr(
      tbl: dbTables.tableCustomers,
      where: 'balance > 0',
      whereArgs: [],
    );
    dataList.value = data.map((e) => Customer.fromJson(e)).toList();
  }

  void showAddCustomerModal() {
    final result = Get.dialog(
      DialogPattern(
        title: 'title',
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

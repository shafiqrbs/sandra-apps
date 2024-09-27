import 'package:get/get.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/transaction_methods.dart';
import 'package:sandra/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import '/app/core/base/base_controller.dart';

class OrderCartController extends BaseController {
  List<String> orderCategoryList = [
    'Order taken by',
    'Online',
    'Order table by',
  ];

  final isAdditionalTableSelected = true.obs;
  final showQuantityUpdateList = <int>[].obs;

  var itemQuantities =
      List<int>.filled(10, 1).obs; // Default quantity of 1 for 10 items

  final customerManager = CustomerManager();
  final isShowClearIcon = false.obs;
  final transactionMethodsManager = TransactionMethodsManager();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void changeAdditionTableSelection() {
    isAdditionalTableSelected.value = !isAdditionalTableSelected.value;
  }

  void increaseQuantity(int index) {
    print('on tap');
    itemQuantities[index]++;
  }

  void decreaseQuantity(int index) {
    if (itemQuantities[index] > 1) {
      itemQuantities[index]--;
    }
  }

  void showQuantityUpdate(int index) {
    if (showQuantityUpdateList.contains(index)) {
      showQuantityUpdateList.remove(index);
    } else {
      showQuantityUpdateList.add(index);
    }
  }

  Future<void> addCustomer() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.customer,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
    ) as Customer?;
    print('result: $result');

    if (result != null) {
      customerManager.selectedItem.value = result;
      customerManager.searchTextController.value.text = result.name!;
      customerManager.searchedItems.value = null;
      update();
      notifyChildrens();
      refresh();
    }
  }

  Future<void> updateCustomer(Customer? customer) async {
    if (customer != null) {
      customerManager.searchTextController.value.text = customer.name!;
      customerManager.searchedItems.value = null;
      customerManager.selectedItem.value = customer;
      //FocusScope.of(Get.context!).unfocus();
    }
  }
}

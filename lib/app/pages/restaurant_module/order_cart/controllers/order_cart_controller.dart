import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';

class OrderCartController extends BaseController {
  List<String> orderCategoryList = [
    'Order taken by',
    'Online',
    'Order table by',
  ];

  final isAdditionalTableSelected = true.obs;

  var itemQuantities =
      List<int>.filled(10, 1).obs; // Default quantity of 1 for 10 items

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
}

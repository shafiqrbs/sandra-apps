import 'package:get/get.dart';
import '/app/model/sales.dart';
import '/app/routes/app_pages.dart';

import '/app/core/abstract_controller/sales_controller.dart';

class CreateSalesController extends SalesController {
  @override
  Future<void> onInit() async {
    super.onInit();
    print('I am in CreateSalesController');
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.isNotEmpty && args['sales'] != null) {
      setData(args['sales'] as Sales);
    }
  }

  void goToListPage() {
    Get.offNamed(Routes.salesList);
  }

  void setData(
    Sales sales,
  ) {
    preSales = sales;
    salesItemList.value = sales.salesItem ?? [];
    calculateAllSubtotal();
  }
}

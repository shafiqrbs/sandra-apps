import 'package:get/get.dart';
import '/app/routes/app_pages.dart';

import '/app/core/abstract_controller/sales_controller.dart';

class CreateSalesController extends SalesController {

  void goToListPage() {
    Get.offNamed(Routes.salesList);
  }
}

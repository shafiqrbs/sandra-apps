import 'package:get/get.dart';
import 'package:getx_template/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class CreateExpenseController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void goToListPage() {
    Get.offNamed(
      Routes.expenseList,
    );
  }
}

import 'package:get/get.dart';
import '/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class ExpenseListController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void goToCreatePage() {
    Get.offNamed(
      Routes.createExpense,
    );
  }
}

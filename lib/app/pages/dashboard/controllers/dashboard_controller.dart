import 'package:get/get.dart';
import '/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

enum SelectedTab {
  dashboard,
  report,
}

enum SelectedButtonGroup {
  inventory,
  accounting,
}

class DashboardController extends BaseController {
  final selectedTab = SelectedTab.dashboard.obs;
  final selectedButtonGroup = SelectedButtonGroup.inventory.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void changeTab(SelectedTab dashboard) {
    selectedTab.value = dashboard;
  }

  void goToSales() {
    Get.toNamed(
      Routes.createSales,
    );
  }

  void goToSalesList() {
    Get.toNamed(
      Routes.salesList,
    );
  }

  void gotoExpenseScreen() {}

  void gotoPurchaseScreen() {}

  void goToStockList() {}
}

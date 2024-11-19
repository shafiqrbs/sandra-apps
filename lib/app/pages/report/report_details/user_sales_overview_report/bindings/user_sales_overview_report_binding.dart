import 'package:get/get.dart';
import 'package:sandra/app/pages/report/report_details/user_sales_overview_report/controllers/user_sales_overview_report_controller.dart';

class UserSalesOverviewReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserSalesOverviewReportController>(
      UserSalesOverviewReportController.new,
      fenix: true,
    );
  }
}
  
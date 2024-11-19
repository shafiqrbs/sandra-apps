import 'package:get/get.dart';
import 'package:sandra/app/entity/user_sales_overview_report.dart';
import '/app/core/base/base_controller.dart';

class UserSalesOverviewReportController extends BaseController {
  final userSalesOverViewReport = Rx<UserSalesOverviewReport?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await dataFetcher(future: getUserSalesOverViewReport);
  }

  Future<void> getUserSalesOverViewReport() async {
    final response = await services.getUserSalesOverViewReport();
    if (response != null) {
      userSalesOverViewReport.value = response;
    }
  }
}

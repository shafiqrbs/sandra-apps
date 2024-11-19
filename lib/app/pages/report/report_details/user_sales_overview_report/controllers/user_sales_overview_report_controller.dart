import 'package:get/get.dart';
import 'package:sandra/app/entity/user_sales_overview_report.dart';
import 'package:sandra/app/pdf_views/sales_purchase_pdf_function.dart';
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

  // calculate due amount
  double getDueAmount({
    required double totalAmount,
    required double receiveAmount,
  }) {
    return totalAmount - receiveAmount;
  }

  // calculate outstanding amount
  double getOutstandingAmount({
    required double totalAmount,
    required double receiveAmount,
    required double dueReceiveAmount,
  }) {
    return totalAmount - (receiveAmount + dueReceiveAmount);
  }

  Future<void> generateUserSalesOverviewPdf() async {
    await generateUserSalesOverViewPdf(
      userSalesOverViewReport.value!,
    );
  }
}

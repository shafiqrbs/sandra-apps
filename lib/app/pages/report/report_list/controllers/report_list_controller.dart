import 'package:get/get.dart';
import 'package:sandra/app/entity/system_overview_report.dart';
import '/app/core/base/base_controller.dart';

class ReportListController extends BaseController {
  final systemOverViewReport = Rx<SystemOverViewReport?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> getSystemOverViewReport() async {
    final response = await services.getSystemOverViewReport(
      userId: loggedUser.userId.toString(),
    );
    if (response != null) {
      systemOverViewReport.value = response;
    }
  }

  Future<void> goToSystemOverviewReport() async {
    await dataFetcher(future: getSystemOverViewReport);
  }
}

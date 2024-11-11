import 'package:get/get.dart';
import 'package:sandra/app/entity/system_overview_report.dart';
import 'package:sandra/app/routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class ReportListController extends BaseController {
  final systemOverViewReport = Rx<SystemOverViewReport?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> goToSystemOverviewReport() async {
    Get.toNamed(Routes.systemOverviewReport);
  }
}

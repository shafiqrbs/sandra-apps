import 'package:get/get.dart';

import '../controllers/system_overview_report_controller.dart';

class SystemOverviewReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SystemOverviewReportController>(
      SystemOverviewReportController.new,
      fenix: true,
    );
  }
}

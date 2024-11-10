import 'package:get/get.dart';
import 'package:sandra/app/pages/report/report_list/controllers/report_list_controller.dart';

class ReportListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportListController>(
      ReportListController.new,
      fenix: true,
    );
  }
}
  
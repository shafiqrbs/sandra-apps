import 'package:get/get.dart';
import 'package:sandra/app/pages/report/report_details/controllers/report_details_controller.dart';

class ReportDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportDetailsController>(
      ReportDetailsController.new,
      fenix: true,
    );
  }
}
  
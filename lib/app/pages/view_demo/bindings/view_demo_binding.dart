import 'package:get/get.dart';
import '/app/pages/view_demo/controllers/view_demo_controller.dart';

class ViewDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewDemoController>(
      () => ViewDemoController(),
      fenix: true,
    );
  }
}
  
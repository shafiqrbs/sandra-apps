import 'package:get/get.dart';
import '/app/pages/inventory/particular/controllers/particular_controller.dart';

class ParticularBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParticularController>(
      ParticularController.new,
      fenix: true,
    );
  }
}

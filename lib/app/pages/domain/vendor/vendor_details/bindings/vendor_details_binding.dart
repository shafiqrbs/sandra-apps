import 'package:get/get.dart';
import '/app/pages/domain/vendor/vendor_details/controllers/vendor_details_controller.dart';

class VendorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorDetailsController>(
      VendorDetailsController.new,
      fenix: true,
    );
  }
}

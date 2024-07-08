import 'package:get/get.dart';
import '/app/pages/domain/vendor/vendor_list/controllers/vendor_list_controller.dart';

class VendorListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorListController>(
      () => VendorListController(),
      fenix: true,
    );
  }
}
  
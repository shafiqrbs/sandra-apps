import 'package:get/get.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';

class CreateStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateStoreController>(
      CreateStoreController.new,
      fenix: true,
    );
  }
}
  
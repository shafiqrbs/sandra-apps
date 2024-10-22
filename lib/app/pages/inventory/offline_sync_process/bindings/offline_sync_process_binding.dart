import 'package:get/get.dart';
import '/app/pages/inventory/offline_sync_process/controllers/offline_sync_process_controller.dart';

class OfflineSyncProcessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineSyncProcessController>(
      () => OfflineSyncProcessController(),
      fenix: true,
    );
  }
}
  
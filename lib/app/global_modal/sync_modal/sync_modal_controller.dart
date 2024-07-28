import 'package:get/get.dart';
import 'package:sandra/app/core/base/base_controller.dart';

class SyncModalController extends BaseController{
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> syncCustomer() async {
    await dataFetcher(
      future: () async {
        await 5.delay();
        //await services.syncCustomer();
      },
    );
  }

  void sync() {
    final
  }
}

import 'package:sandra/app/core/base/base_controller.dart';

class SalesReturnListController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
    await services.getSalesReturnList(
      page: 1,
    );
  }
}

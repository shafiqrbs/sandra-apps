import 'package:get/get.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/add_particular_modal/add_particular_view.dart';
import '/app/core/base/base_controller.dart';

class ParticularController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> showAddParticularModal() async {
    final result = Get.dialog(
      DialogPattern(
        title: 'add_particular'.tr,
        subTitle: 'add_particular_sub_title'.tr,
        child: AddParticularView(),
      ),
    );
  }
}

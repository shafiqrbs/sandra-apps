import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/dialog_pattern.dart';
import 'package:getx_template/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';
import 'package:getx_template/app/model/vendor.dart';
import '/app/core/base/base_controller.dart';

class VendorListController extends BaseController {
  final vendorManager = VendorManager();
  final isSearchSelected = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await vendorManager.paginate();
  }

  void showAddVendorModal() {
    final result = Get.dialog(
      DialogPattern(
        title: 'add_vendor'.tr,
        subTitle: '',
        child: AddVendorModalView(),
      ),
    );
  }

  Future<void> onClearSearchText() async {
    vendorManager.searchTextController.value.clear();
    isSearchSelected.value = false;
    await vendorManager.paginate();
  }
}

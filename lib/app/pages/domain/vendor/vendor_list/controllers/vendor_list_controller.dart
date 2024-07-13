import 'package:get/get.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/add_vendor_modal/add_vendor_modal_view.dart';
import '/app/entity/vendor.dart';
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
        title: appLocalization.addVendor,
        subTitle: '',
        child: AddVendorModalView(),
      ),
    );
  }

  Future<void> onClearSearchText() async {
    vendorManager.searchTextController.value.clear();
    vendorManager.allItems.value?.clear();
    vendorManager.allItems.refresh();
    isSearchSelected.value = false;
    await vendorManager.paginate();
  }
}

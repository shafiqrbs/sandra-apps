import 'package:get/get.dart';
import 'package:sandra/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';
import 'package:sandra/app/routes/app_pages.dart';
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
        title: appLocalization.createVendor,
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

  Future<void> showVendorPaymentModal(Vendor? element) async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.payment,
        subTitle: '',
        child: VendorPaymentModalView(
          vendor: element,
        ),
      ),
    );
    if (isNewReceived != null && isNewReceived) {
      Get.offNamed(
        Routes.accountingPurchase,
      );
    }
  }
}

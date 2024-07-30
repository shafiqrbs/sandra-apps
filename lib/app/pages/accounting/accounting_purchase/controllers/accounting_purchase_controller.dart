import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/vendor.dart';
import '/app/entity/vendor_ledger.dart';
import '/app/global_modal/vendor_payment_modal/vendor_payment_modal_view.dart';
import '/app/core/base/base_controller.dart';

class AccountingPurchaseController extends BaseController {
  final purchaseList = VendorLedgerManager();
  final isSearchSelected = false.obs;

  Vendor? selectedVendor;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchPurchaseList();
  }

  Future<void> fetchPurchaseList() async {
    await dataFetcher(
      future: () async {
        final value = await services.getAccountPurchaseList(
          vendorId: selectedVendor?.vendorId?.toString(),
          startDate: startDate,
          endDate: endDate,
          keyword: searchQuery,
        );

        if (value != null) {
          purchaseList.allItems.value = value;
        }
      },
    );
  }

  showFilterModal({
    required BuildContext context,
  }) {}

  onClearSearchText() {}

  void goToCreateSales() {}

  showSalesInformationModal(
    BuildContext context,
    VendorLedger element,
  ) {}

  void showVendorPaymentModal() {
    Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: VendorPaymentModalView(
          vendor: selectedVendor,
        ),
      ),
    );
  }

  Future<void> deletePurchase() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      toast('Under Development');
    } else {}
  }

  Future<void> approvePurchase() async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      toast('Under Development');
    } else {}
  }
}

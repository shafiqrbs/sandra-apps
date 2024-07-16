import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/dialog_pattern.dart';
import 'package:sandra/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/core/base/base_controller.dart';

class AccountingSalesController extends BaseController {
  final salesList = CustomerLedgerManager();
  final isSearchSelected = false.obs;

  Customer? selectedCustomer;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchSalesList();
  }

  Future<void> fetchSalesList() async {
    await dataFetcher(
      future: () async {
        final value = await services.getAccountSalesList(
          customerId: selectedCustomer?.customerId?.toString(),
          startDate: startDate,
          endDate: endDate,
          keyword: searchQuery,
        );

        if (value != null) {
          salesList.allItems.value = value;
        }
      },
    );
  }

  onClearSearchText() {}

  showFilterModal({required BuildContext context}) {}

  void goToCreateSales() {}

  showSalesInformationModal(BuildContext context, CustomerLedger element) {}

  void showCustomerReceiveModal() {
    Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: '',
        child: CustomerReceiveModalView(
          customer: null,
        ),
      ),
    );
  }
}

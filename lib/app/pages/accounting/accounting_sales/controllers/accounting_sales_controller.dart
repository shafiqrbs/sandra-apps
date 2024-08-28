import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/logged_user.dart';
import '/app/core/utils/static_utility_function.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';

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

  void onClearSearchText() {
    salesList.searchTextController.value.clear();
    isSearchSelected.value = false;
  }

  void showFilterModal({
    required BuildContext context,
  }) {}

  void goToCreateSales() {}

  void showSalesInformationModal(
    BuildContext context,
    CustomerLedger element,
  ) {}

  Future<void> showCustomerReceiveModal() async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.newReceive,
        subTitle: '',
        child: CustomerReceiveModalView(
          customer: null,
        ),
      ),
    );
    if (isNewReceived == true) {
      salesList.allItems.value = null;
      salesList.allItems.refresh();
      await fetchSalesList();
    }
  }

  Future<void> deleteSale(int salesId) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isDeleted;
      await dataFetcher(
        future: () async {
          isDeleted = await services.deleteAccountSale(
            id: salesId.toString(),
          );
        },
      );
      if (isDeleted ?? false) {
        salesList.allItems.value?.removeWhere(
          (element) => element.id == salesId,
        );
        salesList.allItems.refresh();
      }
    }
  }

  Future<void> approveSale({
    required int salesId,
    required int index,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isApproved;
      await dataFetcher(
        future: () async {
          isApproved = await services.approveAccountSale(
            id: salesId.toString(),
          );
        },
      );
      if (isApproved ?? false) {
        salesList.allItems.value?[index].approvedBy = LoggedUser().username;
        salesList.allItems.refresh();
      }
    }
  }
}

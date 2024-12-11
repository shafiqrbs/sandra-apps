import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sandra/app/global_modal/sales_information_modal/sales_information_without_invoice_modal_view.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/page_state.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import '/app/global_modal/sales_information_modal/sales_information_modal_view.dart';

class AccountingSalesController extends BaseController {
  final searchTextController = TextEditingController().obs;
  final pagingController = Rx<PagingController<int, CustomerLedger>>(
    PagingController<int, CustomerLedger>(
      firstPageKey: 1,
    ),
  );
  final isSearchSelected = false.obs;

  Customer? selectedCustomer;
  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();

    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchSalesList(
          pageKey: pageKey,
        );
      },
    );
    try {
      updatePageState(PageState.loading);
      await fetchSalesList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

  Future<void> fetchSalesList({
    required int pageKey,
  }) async {
    List<CustomerLedger>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getAccountSalesList(
          customerId: selectedCustomer?.customerId?.toString(),
          startDate: startDate,
          endDate: endDate,
          keyword: searchQuery,
          page: pageKey,
        );
      },
      shouldShowLoader: false,
    );

    if (apiDataList == null) {
      pagingController.value.error = true;
      return;
    }

    if ((apiDataList?.length ?? 0) < pageLimit) {
      pagingController.value.appendLastPage(apiDataList!);
    } else {
      pagingController.value.appendPage(
        apiDataList!,
        pageKey + 1,
      );
    }

    update();
    refresh();
    notifyChildrens();
  }

  Future<void> onClearSearchText() async {
    searchTextController.value.clear();
    isSearchSelected.value = false;
    if (searchQuery != null ||
        selectedCustomer != null ||
        startDate != null ||
        endDate != null) {
      searchQuery = null;
      selectedCustomer = null;
      startDate = null;
      endDate = null;
      await refreshData();
    }
  }

  Future<void> showFilterModal({
    required BuildContext context,
  }) async {
    final value = await Get.dialog(
      DialogPattern(
        title: appLocalization.sales,
        subTitle: '',
        child: GlobalFilterModalView(),
      ),
    );

    if (value != null && value is Map) {
      startDate = value['start_date'];
      endDate = value['end_date'];
      selectedCustomer = value['customer'];
      searchQuery = value['search_keyword'];
      await refreshData();
    }
  }

  void goToCreateSales() {}

  Future<void> showSalesInformationModal(
    BuildContext context,
    CustomerLedger element,
  ) async {
    if (element.sourceInvoice != null) {
      final invoice = Sales(
        salesId: element.sourceInvoice.toString(),
      );
      await Get.dialog(
        DialogPattern(
          title: appLocalization.salesDetails,
          subTitle: element.customerName ?? '',
          child: SalesInformationModalView(
            sales: invoice,
            salesMode: 'online',
            isShowFooter: false,
            isFromAccount: true,
          ),
        ),
      );
    } else {
      await Get.dialog(
        DialogPattern(
          title: appLocalization.salesDetails,
          subTitle: '',
          child: SalesInformationWithoutInvoiceModalView(
            customerLedger: element,
            salesMode: 'online',
            isShowFooter: false,
            isFromAccount: true,
          ),
        ),
      );
    }
  }

  Future<void> showCustomerReceiveModal() async {
    final isNewReceived = await Get.dialog(
      DialogPattern(
        title: appLocalization.salesReceive,
        subTitle: '',
        child: CustomerReceiveModalView(
          customer: null,
        ),
      ),
    );
    if (isNewReceived == true) {
      await refreshData();
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
        await refreshData();
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
        await refreshData();
      }
    }
  }

  Future<void> onSearch(String value) async {
    debouncer.call(
      () async {
        searchQuery = value;
        refreshData();
      },
    );
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchSalesList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }
}

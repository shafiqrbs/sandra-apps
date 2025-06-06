import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/global_modal/add_customer_modal/add_customer_modal_view.dart';
import 'package:sandra/app/pages/domain/customer/customer_list/controllers/customer_list_controller.dart';
import 'package:sandra/app/pdf_views/sales_purchase_pdf_function.dart';

import '/app/core/widget/show_snack_bar.dart';
import '/app/entity/customer.dart';
import '/app/entity/customer_ledger.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/customer_receive_modal/customer_receive_modal_view.dart';
import '/app/global_modal/sales_information_modal/sales_information_modal_view.dart';

class CustomerLedgerController extends BaseController {
  Customer? customer;

  final customerManager = CustomerManager();
  final pagingController = Rx<PagingController<int, CustomerLedger>>(
    PagingController<int, CustomerLedger>(
      firstPageKey: 1,
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      customer = args['customer'];
      customerManager.selectedItem.value = customer;
    }

    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchLedgerReport(
          pageKey: pageKey,
        );
      },
    );

    try {
      updatePageState(PageState.loading);
      await fetchLedgerReport(
        pageKey: 1,
      );
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

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
          ),
        ),
      );
    } else {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.invoiceDataNotAvailable,
      );
    }
  }

  Future<void> fetchLedgerReport({
    required int pageKey,
  }) async {
    List<CustomerLedger>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getCustomerLedgerReport(
          customerId: customer!.customerId.toString(),
          pageKey: pageKey,
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

  Future<void> updateCustomer(Customer data) async {
    // Clear the selected item and search results
    customerManager.selectedItem.value = null;
    customerManager.searchedItems.value = null;

    // Update the search text controller with the customer's name
    customerManager.searchTextController.value.text = data.name ?? '';

    // Set the selected item to the new customer data
    customerManager.selectedItem.value = data;

    // Refresh the selected item to notify listeners
    customerManager.selectedItem.refresh();
    customer = data;
    await refreshData();
    // Unfocus the current focus scope to hide the keyboard
    FocusScope.of(Get.context!).unfocus();

    // Update the state and notify children widgets
    update();
    notifyChildrens();
    refresh();
  }

  void clearSearch() {
    customerManager.searchTextController.value.clear();
    customerManager.searchedItems.value = null;
    customerManager.searchTextController.refresh();
  }

  Future<void> startVoiceSearch() async {
    if (!voiceRecognition.isListening) {
      await voiceRecognition.startListening(
        (result) {
          customerManager.searchTextController.value.text = result;
          customerManager.searchItemsByName(result);
        },
      );
    } else {
      await voiceRecognition.stopListening();
    }
  }

  void searchCustomer(String value) {
    customerManager.searchItemsByName(value);
    customerManager.searchTextController.refresh();
  }

  void showReceiveModal() {
    Get.dialog(
      DialogPattern(
        title: appLocalization.salesReceive,
        subTitle: '',
        child: CustomerReceiveModalView(
          customer: customer,
        ),
      ),
    );
  }

  Future<void> createLedgerPdf({
    required List<CustomerLedger> customerLedgerReport,
    required Customer customer,
  }) async {
    await generateCustomerLedgerPdf(
      ledger: customerLedgerReport,
      customer: customer,
    );
  }

  Future<void> printCustomerLedger({
    required List<CustomerLedger> customerLedgerReport,
    required Customer customer,
  }) async {
    PrinterController().printCustomerLedger(
      ledger: customerLedgerReport,
      customer: customer,
    );
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchLedgerReport(
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

  Future<void> showEditCustomerModal() async {
    final data = await Get.dialog(
      DialogPattern(
        title: appLocalization.edit,
        subTitle: '',
        child: AddCustomerModalView(),
      ),
      arguments: {
        'customer': customer,
      },
    );
    if (data != null && data is Customer) {
      await updateCustomer(data);
      if (Get.isRegistered<CustomerListController>()) {
        await Get.find<CustomerListController>().onClearSearchText();
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '/app/core/core_model/page_state.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/entity/expense.dart';
import '/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/add_expense_modal/add_expense_view.dart';

class ExpenseListController extends BaseController {
  final searchTextController = TextEditingController().obs;
  final pagingController = Rx<PagingController<int, Expense>>(
    PagingController<int, Expense>(
      firstPageKey: 1,
    ),
  );
  final isSearchSelected = false.obs;

  String? startDate;
  String? endDate;
  String? searchQuery;

  @override
  Future<void> onInit() async {
    super.onInit();
    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchExpenseList(
          pageKey: pageKey,
        );
      },
    );
    try {
      updatePageState(PageState.loading);
      await fetchExpenseList(
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

  Future<void> fetchExpenseList({
    required int pageKey,
  }) async {
    List<Expense>? apiDataList;

    await dataFetcher(
      future: () async {
        apiDataList = await services.getExpenseList(
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

  Future<void> showAddExpenseModal() async {
    final result = await Get.dialog(
      DialogPattern(
        title: appLocalization.addExpense,
        subTitle: '',
        child: AddExpenseView(),
      ),
    );
    if (result != null && result) {
      await refreshData();
    }
  }

  Future<void> onSearch(String value) async {
    debouncer.call(
      () async {
        searchQuery = value;
        if (value.isNotEmpty) {
          isSearchSelected.value = true;
        } else {
          isSearchSelected.value = false;
        }
        refreshData();
      },
    );
  }

  Future<void> deleteExpense({
    required String expenseId,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isDeleted;
      await dataFetcher(
        future: () async {
          isDeleted = await services.deleteExpense(
            id: expenseId,
          );
        },
      );
      if (isDeleted ?? false) {
        await refreshData();
      }
    }
  }

  Future<void> approveExpense({
    required String expenseId,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isApproved;
      await dataFetcher(
        future: () async {
          isApproved = await services.approveExpense(
            id: expenseId,
          );
        },
      );
      if (isApproved ?? false) {
        await refreshData();
      }
    }
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchExpenseList(
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

  void showExpenseInformationModal(
    BuildContext context,
    Expense element,
  ) {}

  Future<void> showFilterModal() async {
    final value = await Get.dialog(
      DialogPattern(
        title: 'title',
        subTitle: 'subTitle',
        child: GlobalFilterModalView(
          showCustomer: false,
          showVendor: false,
        ),
      ),
    );

    if (value != null && value is Map) {
      startDate = value['start_date'];
      endDate = value['end_date'];
      searchQuery = value['search_keyword'];
      await refreshData();
    }
  }

  Future<void> onClearSearchText() async {
    isSearchSelected.value = false;
    if (searchQuery != null || startDate != null || endDate != null) {
      searchQuery = null;
      startDate = null;
      endDate = null;
      await refreshData();
    }
  }
}

import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/sales_return.dart';

import 'modals/sales_return_information_modal.dart';

class SalesReturnListController extends BaseController {
  final pagingController = Rx<PagingController<int, SalesReturn>>(
    PagingController<int, SalesReturn>(
      firstPageKey: 1,
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();

    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchOnlineList(
          pageKey: pageKey,
        );
      },
    );
    try {
      updatePageState(PageState.loading);
      await fetchOnlineList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }

    await services.getSalesReturnList(
      page: 1,
    );
  }

  Future<void> fetchOnlineList({
    required int pageKey,
  }) async {
    final apiDataList = await services.getSalesReturnList(
      page: pageKey,
    );
    if (apiDataList == null) {
      pagingController.value.error = true;
      return;
    }

    if ((apiDataList.length) < pageLimit) {
      pagingController.value.appendLastPage(apiDataList);
    } else {
      pagingController.value.appendPage(
        apiDataList,
        pageKey + 1,
      );
    }
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchOnlineList(
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

  showSalesInformationModal(
    BuildContext context,
    SalesReturn element,
  ) {
    Get.dialog(
      DialogPattern(
        title: appLocalization.salesReturn,
        subTitle: '',
        child: SalesReturnInformationModalView(element: element),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/entity/sync_list.dart';
import '/app/core/base/base_controller.dart';

class OfflineSyncProcessController extends BaseController {
  final syncList = Rx<List<SyncList>?>(null);
  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchSyncList();
  }

  Future<void> fetchSyncList() async {
    try {
      updatePageState(PageState.loading);
      syncList.value = await services.getSyncList();
    } finally {
      if (syncList.value == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

  Future<void> approve({
    required SyncList element,
    required int index,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );
    if (confirmation) {
      bool? isApproved;
      await dataFetcher(
        future: () async {
          isApproved = await services.approveSyncList(
            element: element,
          );
        },
      );
      if (isApproved ?? false) {
        syncList.value!.removeAt(index);
        syncList.refresh();
      }
    }
  }

  Future<void> refreshData() async {
    await fetchSyncList();
  }
}

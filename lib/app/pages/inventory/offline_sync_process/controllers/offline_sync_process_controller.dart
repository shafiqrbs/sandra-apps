import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/entity/sync_list.dart';
import '/app/core/base/base_controller.dart';

class OfflineSyncProcessController extends BaseController {
  final syncList = Rx<List<SyncList>?>(null);
  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      updatePageState(PageState.loading);
      await fetchSyncList();
    } finally {
      if (syncList.value == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

  Future<void> fetchSyncList() async {
    await dataFetcher(
      future: () async {
        syncList.value = await services.getSyncList();
      },
    );
  }
}

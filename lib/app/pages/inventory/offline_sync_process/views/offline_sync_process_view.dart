import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/page_state.dart';
import 'package:sandra/app/core/values/app_strings.dart';
import 'package:sandra/app/core/widget/common_icon_text.dart';
import 'package:sandra/app/core/widget/delete_button.dart';
import 'package:sandra/app/core/widget/no_record_found_view.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
import 'package:sandra/app/core/widget/retry_view.dart';
import 'package:sandra/app/entity/sync_list.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/offline_sync_process/controllers/offline_sync_process_controller.dart';

//ignore: must_be_immutable
class OfflineSyncProcessView extends BaseView<OfflineSyncProcessController> {
  OfflineSyncProcessView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.syncList,
      ),
      automaticallyImplyLeading: false,
      actions: [
        QuickNavigationButton(),
        10.width,
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: appBar(context),
      body: Column(
        children: [
          Obx(
            () {
              final pageState = controller.pageState;
              if (pageState == PageState.loading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: loaderColor,
                    ),
                  ),
                );
              }

              if (pageState == PageState.failed) {
                return RetryView(
                  onRetry: controller.refreshData,
                );
              }

              if (pageState == PageState.success) {
                final items = controller.syncList.value;

                final isEmpty = items?.isEmpty ?? true;
                if (isEmpty) {
                  return NoRecordFoundView(
                    onTap: controller.refreshData,
                  );
                }

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshData,
                    child: _buildListView(),
                  ),
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: controller.syncList.value?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = controller.syncList.value![index];
        return _buildCardView(
          element: item,
          index: index,
          context: context,
        );
      },
    );
  }

  Widget _buildCardView({
    required SyncList element,
    required int index,
    required BuildContext context,
  }) {
    final createdDate = element.created != null
        ? DateFormat(dateFormat).format(
            DateFormat(apiDateFormat).parse(element.created!),
          )
        : '';
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
          top: index == 0 ? 8 : 0,
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: index.isEven
                    ? colors.secondaryColor50
                    : colors.primaryColor50,
                borderRadius: BorderRadius.circular(containerBorderRadius),
                border: Border.all(
                  color: index.isEven
                      ? colors.secondaryColor100
                      : colors.primaryColor100,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          text: createdDate,
                          icon: TablerIcons.calendar_due,
                          fontSize: valueTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          text: element.deviceName ?? 'N/A',
                          icon: TablerIcons.file_invoice,
                          fontSize: valueTFSize,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          text: element.process ?? '',
                          icon: TablerIcons.user,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: valueTFSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 4,
              child: IconButton(
                onPressed: () => controller.approve(
                  element: element,
                  index: index,
                ),
                icon: Icon(
                  TablerIcons.check,
                  color: colors.primaryColor500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

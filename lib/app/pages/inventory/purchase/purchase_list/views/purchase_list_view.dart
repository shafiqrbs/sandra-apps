import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:sandra/app/core/values/app_strings.dart';

import '/app/core/base/base_view.dart';
import '/app/core/core_model/page_state.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/delete_button.dart';
import '/app/core/widget/no_record_found_view.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/retry_view.dart';
import '/app/core/widget/search_button.dart';
import '/app/core/widget/sub_tab_item_view.dart';
import '/app/entity/purchase.dart';
import '/app/pages/inventory/purchase/purchase_list/controllers/purchase_list_controller.dart';

//ignore: must_be_immutable
class PurchaseListView extends BaseView<PurchaseListController> {
  PurchaseListView({super.key});
  final String currency = SetUp().symbol ?? '';

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () => AppBarSearchView(
          pageTitle: appLocalization.purchase,
          controller: controller.purchaseManager.searchTextController.value,
          onSearch: controller.onSearch,
          onMicTap: controller.isSearchSelected.toggle,
          onFilterTap: () => controller.showFilterModal(
            context: globalKey.currentContext!,
          ),
          onClearTap: controller.onClearSearchText,
          showSearchView: controller.isSearchSelected.value,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Obx(
          () => controller.isSearchSelected.value
              ? Container()
              : AppBarButtonGroup(
                  children: [
                    AddButton(
                      onTap: controller.goToCreatePurchase,
                    ),
                    SearchButton(
                      onTap: controller.isSearchSelected.toggle,
                    ),
                    QuickNavigationButton(),
                  ],
                ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: appBar(context),
      body: Column(
        children: [
          Obx(
            () {
              return controller.selectedIndex.value == 1
                  ? _buildPurchaseListView(
                      _buildOnlinePurchaseListView,
                    )
                  : _buildPurchaseListView(
                      _buildOfflinePurchaseListView,
                    );
            },
          ),
          _buildTabSelector(),
        ],
      ),
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: floatingActionButtonLocation(),
    );
  }

  Widget _buildPurchaseListView(
    Widget Function() builder,
  ) {
    return Obx(
      () {
        final pageState = controller.pageState;
        switch (pageState) {
          case PageState.loading:
            return _buildLoadingView();
          case PageState.failed:
            return Expanded(
              child: RetryView(
                onRetry: controller.refreshData,
              ),
            );
          case PageState.success:
            return builder();
          default:
            return Container();
        }
      },
    );
  }

  Widget _buildLoadingView() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(
          color: loaderColor,
        ),
      ),
    );
  }

  Widget _buildOnlinePurchaseListView() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: PagedListView<int, Purchase>(
          pagingController: controller.pagingController.value,
          builderDelegate: PagedChildBuilderDelegate<Purchase>(
            itemBuilder: (context, element, index) => _buildPurchaseCardView(
              element: element,
              index: index,
              context: context,
            ),
            noItemsFoundIndicatorBuilder: (_) => NoRecordFoundView(
              onTap: controller.refreshData,
            ),
            newPageErrorIndicatorBuilder: (context) {
              return listViewRetryView(
                onRetry:
                    controller.pagingController.value.retryLastFailedRequest,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOfflinePurchaseListView() {
    final items = controller.purchaseManager.allItems.value;
    if (items == null || items.isEmpty) {
      return Expanded(
        child: NoRecordFoundView(
          onTap: controller.refreshData,
        ),
      );
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          controller: controller.purchaseManager.scrollController,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return _buildPurchaseCardView(
              element: items[index],
              index: index,
              context: context,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPurchaseCardView({
    required Purchase element,
    required int index,
    required BuildContext context,
  }) {
    final createdDate = element.createdAt != null
        ? DateFormat(dateFormat).format(
            DateFormat(apiDateFormat).parse(element.createdAt!),
          )
        : '';
    return InkWell(
      onTap: () => controller.showPurchaseInformationModal(
        context,
        element,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
              top: index == 0 ? 8 : 0,
            ),
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
                        text: element.invoice ?? '',
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
                        text: element.vendorName ?? '',
                        icon: TablerIcons.user,
                        textOverflow: TextOverflow.ellipsis,
                        fontSize: valueTFSize,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: element.vendorMobile ?? '',
                        icon: TablerIcons.device_mobile,
                        fontSize: valueTFSize,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text:
                              "${appLocalization.total} : $currency ${element.netTotal ?? ''}",
                          fontSize: valueTFSize,
                          textColor: colors.solidBlackColor,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text:
                              "${appLocalization.receive} : $currency ${element.received ?? ''}",
                          fontSize: valueTFSize,
                          textColor: colors.solidBlackColor,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text:
                              "${appLocalization.due} :$currency ${element.due ?? ''}",
                          fontSize: valueTFSize,
                          textColor: colors.solidBlackColor,
                          textAlign: TextAlign.start,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (element.approvedBy == null)
            if (controller.isManager)
              Positioned(
                right: 10,
                top: 18,
                child: DeleteButton(
                  onTap: () => controller.deletePurchase(
                    purchaseId: element.purchaseId!,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: List.generate(
        controller.tabPages.length,
        (index) {
          return Obx(
            () => Expanded(
              child: SubTabItemView(
                isSelected: controller.selectedIndex.value == index,
                item: controller.tabPages[index],
                onTap: () => controller.changeTab(index),
                localeMethod: controller.tabPages[index].localeMethod,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  FloatingActionButtonLocation? floatingActionButtonLocation() {
    return FloatingActionButtonLocation.endFloat;
  }

  @override
  Widget? floatingActionButton() {
    return Obx(
      () {
        if (controller.selectedIndex.value == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 48),
            child: InkWell(
              onTap: controller.syncPurchase,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.blackColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      TablerIcons.refresh,
                      color: colors.whiteColor,
                      size: 18,
                    ),
                    CommonText(
                      text: appLocalization.sync,
                      textColor: colors.whiteColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

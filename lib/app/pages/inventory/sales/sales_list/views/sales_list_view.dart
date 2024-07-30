import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import '/app/core/widget/no_record_found_view.dart';
import '/app/core/widget/retry_view.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/search_button.dart';
import '/app/core/widget/sub_tab_item_view.dart';
import '/app/pages/inventory/sales/sales_list/controllers/sales_list_controller.dart';

//ignore: must_be_immutable
class SalesListView extends BaseView<SalesListController> {
  SalesListView({super.key});

  final currency = SetUp().currency ?? '';

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.sales,
            controller: controller.salesManager.searchTextController.value,
            onSearch: controller.salesManager.searchItemsByNameOnAllItem,
            onMicTap: controller.isSearchSelected.toggle,
            onFilterTap: () => controller.showFilterModal(
              context: globalKey.currentContext!,
            ),
            onClearTap: controller.onClearSearchText,
            showSearchView: controller.isSearchSelected.value,
          );
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        Obx(
          () {
            if (controller.isSearchSelected.value) {
              return Container();
            }
            return AppBarButtonGroup(
              children: [
                AddButton(
                  onTap: controller.goToCreateSales,
                ),
                SearchButton(
                  onTap: controller.isSearchSelected.toggle,
                ),
                QuickNavigationButton(),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            final items = controller.salesManager.allItems.value;

            Widget content;
            if (items == null) {
              content = RetryView(
                onRetry: () => controller.changeIndex(
                  controller.selectedIndex.value,
                ),
              );
            } else if (items.isEmpty) {
              content = const NoRecordFoundView();
            } else {
              content = _buildListView();
            }

            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.changeIndex(controller.selectedIndex.value);
                },
                child: content,
              ),
            );
          },
        ),
        Row(
          children: List.generate(
            controller.tabPages.length,
            (index) {
              return Obx(
                () => Expanded(
                  child: SubTabItemView(
                    isSelected: controller.selectedIndex.value == index,
                    item: controller.tabPages[index],
                    onTap: () => controller.changeIndex(index),
                    localeMethod: controller.tabPages[index].localeMethod,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: controller.salesManager.allItems.value?.length ?? 0,
      controller: controller.selectedIndex.value == 2
          ? null
          : controller.salesManager.scrollController,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        //check ranger is valid

        final element = controller.salesManager.allItems.value![index];
        final createdDate = element.createdAt != null
            ? DateFormat('dd MMM yyyy').format(
                DateFormat('MM-dd-yyyy hh:mm a').parse(element.createdAt!),
              )
            : '';

        return InkWell(
          onTap: () => controller.showSalesInformationModal(
            context,
            element,
          ),
          child: Container(
            margin: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
              top: index == 0 ? 8 : 0,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: index.isEven ? colors.evenListColor : colors.oddListColor,
              borderRadius: BorderRadius.circular(containerBorderRadius),
              border: Border.all(
                color: colors.tertiaryBaseColor,
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
                        text: '${element.salesId}',
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
                        text: element.customerName ?? '',
                        icon: TablerIcons.user,
                        textOverflow: TextOverflow.ellipsis,
                        fontSize: valueTFSize,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: element.customerMobile ?? '',
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
                          textColor: colors.primaryTextColor,
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
                          textColor: colors.primaryTextColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text: "${appLocalization.due} :$currency ${element.due ?? ""}",
                          fontSize: valueTFSize,
                          textColor: colors.primaryTextColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

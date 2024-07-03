import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/utils/style_function.dart';
import 'package:getx_template/app/core/widget/app_bar_button.dart';
import 'package:getx_template/app/core/widget/app_bar_button_group.dart';
import 'package:getx_template/app/core/widget/app_bar_search_view.dart';
import 'package:getx_template/app/core/widget/filter_button.dart';
import 'package:getx_template/app/core/widget/quick_navigation_button.dart';
import 'package:getx_template/app/core/widget/search_button.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/sub_tab_item_view.dart';
import '/app/pages/sales_list/controllers/sales_list_controller.dart';

//ignore: must_be_immutable
class SalesListView extends BaseView<SalesListController> {
  SalesListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: 'sales'.tr,
            controller: controller.customerManager.searchTextController.value,
            onSearch: controller.customerManager.searchItemsByNameOnAllItem,
            onMicTap: controller.isSearchSelected.toggle,
            onFilterTap: () => controller.showFilterModal(
              context: globalKey.currentContext!,
            ),
            onClearTap: controller.isSearchSelected.toggle,
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
                FilterButton(
                  onTap: () => controller.showFilterModal(
                    context: globalKey.currentContext!,
                  ),
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
                  ),
                ),
              );
            },
          ),
        ),
        Obx(
          () {
            return Expanded(
              child: ListView.builder(
                itemCount: controller.salesManager.allItems.value?.length ?? 0,
                controller: controller.selectedIndex.value == 2
                    ? null
                    : controller.salesManager.scrollController,
                padding: const EdgeInsets.only(bottom: 60),
                itemBuilder: (context, index) {
                  final element =
                      controller.salesManager.allItems.value![index];

                  return InkWell(
                    onTap: () async {},
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? colors.evenListColor
                            : colors.oddListColor,
                        borderRadius:
                            BorderRadius.circular(containerBorderRadius),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CommonIconText(
                                  text: '${element.salesId}',
                                  icon: TablerIcons.device_mobile,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      TablerIcons.calendar,
                                      size: 18,
                                      color: colors.iconColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        element.createdAt != null
                                            ? DateFormat('dd MMM yyyy').format(
                                                DateFormat('dd-MM-yyyy hh:mm a')
                                                    .parse(element.createdAt!),
                                              )
                                            : '',
                                        style: TextStyle(
                                          color: colors.primaryTextColor,
                                          fontSize: regularTFSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      controller.showSalesInformationModal(
                                    context,
                                    element,
                                  ),
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        containerBorderRadius,
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Icon(
                                      TablerIcons.eye,
                                      color: colors.primaryBaseColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: CommonIconText(
                                  text: element.customerName ?? '',
                                  icon: TablerIcons.user,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                child: CommonIconText(
                                  text: element.customerMobile ?? '',
                                  icon: TablerIcons.device_mobile,
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: CommonText(
                                    text:
                                        "${"total".tr} : ${element.netTotal ?? ''}",
                                    fontSize: regularTFSize,
                                    textColor: colors.primaryTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: CommonText(
                                    text:
                                        "${"receive".tr} : ${element.received ?? ''}",
                                    fontSize: regularTFSize,
                                    textColor: colors.primaryTextColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: CommonText(
                                    text: "${"due".tr} : ${element.due ?? ""}",
                                    fontSize: regularTFSize,
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
              ),
            );
          },
        ),
      ],
    );
  }
}

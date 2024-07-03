import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/app_bar_button_group.dart';
import 'package:getx_template/app/core/widget/app_bar_search_view.dart';
import 'package:getx_template/app/core/widget/common_text.dart';
import 'package:getx_template/app/core/widget/filter_button.dart';
import 'package:getx_template/app/core/widget/quick_navigation_button.dart';
import 'package:getx_template/app/core/widget/search_button.dart';
import 'package:getx_template/app/pages/stock_list/component/stock_card_view.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/stock_list/controllers/stock_list_controller.dart';

//ignore: must_be_immutable
class StockListView extends BaseView<StockListController> {
  StockListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: 'stock_list'.tr,
            controller: controller.stockManager.searchTextController.value,
            onSearch: controller.stockManager.searchItemsByNameOnAllItem,
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
    return Obx(
      () {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.stockManager.allItems.value?.length ?? 0,
          itemBuilder: (context, index) {
            final element = controller.stockManager.allItems.value![index];
            final isSelectedItem = false.obs;
            final isBookmarked = false.obs;

            return StockCardView(
              element: element,
              index: index,
              isSelectedItem: isSelectedItem,
              isBookmarked: isBookmarked,
            );
          },
        );
      },
    );
  }
}

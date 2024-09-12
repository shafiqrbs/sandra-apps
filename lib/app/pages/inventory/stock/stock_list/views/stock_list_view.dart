import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/no_record_found_view.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/retry_view.dart';
import '/app/core/widget/search_button.dart';
import '/app/pages/inventory/stock/stock_list/component/stock_card_view.dart';
import '/app/pages/inventory/stock/stock_list/controllers/stock_list_controller.dart';

//ignore: must_be_immutable
class StockListView extends BaseView<StockListController> {
  StockListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.stockList,
            controller: controller.stockManager.searchTextController.value,
            onSearch: controller.stockManager.searchItemsByNameOnAllItem,
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
                  onTap: controller.showAddStockModal,
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
        final items = controller.stockManager.allItems.value;

        Widget content;
        if (items == null) {
          content = RetryView(
            onRetry: () {},
          );
        } else if (items.isEmpty) {
          content = NoRecordFoundView();
        } else {
          content = _buildListView();
        }

        return content;
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.stockManager.allItems.value?.length ?? 0,
      controller: controller.stockManager.scrollController,
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
  }
}

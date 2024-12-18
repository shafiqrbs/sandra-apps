import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/drop_down_decoration.dart';
import 'package:sandra/app/entity/brand.dart';
import 'package:sandra/app/entity/category.dart';

import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_search_view.dart';
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
            onFilterTap: () {},
            onClearTap: controller.onClearSearchText,
            showSearchView: controller.isSearchSelected.value,
            isShowFilter: false,
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  DropdownFlutter<Brand>.search(
                    controller: controller.brandManager.ddController,
                    hintText: appLocalization.brand,
                    items: controller.brandManager.allItems.value,
                    onChanged: controller.onBrandSelection,
                    overlayHeight: 500,
                    listItemBuilder: (context, value, ___, option) {
                      return Text(
                        value.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    headerBuilder: (context, value, option) {
                      return Text(
                        value.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    decoration: dropDownDecoration,
                    itemsListPadding: EdgeInsets.zero,
                    closedHeaderPadding: const EdgeInsets.all(8),
                  ),
                  DropdownFlutter<Category>.search(
                    controller: controller.categoryManager.ddController,
                    hintText: appLocalization.category,
                    items: controller.categoryManager.allItems.value,
                    onChanged: controller.onCategorySelection,
                    overlayHeight: 500,
                    listItemBuilder: (context, value, ___, option) {
                      return Text(
                        value.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    headerBuilder: (context, value, option) {
                      return Text(
                        value.name ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    decoration: dropDownDecoration,
                    itemsListPadding: EdgeInsets.zero,
                    closedHeaderPadding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            Expanded(child: content),
          ],
        );
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
          onTap: controller.showStockDetailsModal,
          index: index,
          isSelectedItem: isSelectedItem,
          isBookmarked: isBookmarked,
        );
      },
    );
  }
}

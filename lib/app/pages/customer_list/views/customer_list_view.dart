import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/add_button.dart';
import 'package:getx_template/app/core/widget/app_bar_button_group.dart';
import 'package:getx_template/app/core/widget/app_bar_search_view.dart';
import 'package:getx_template/app/core/widget/common_icon_text.dart';
import 'package:getx_template/app/core/widget/quick_navigation_button.dart';
import 'package:getx_template/app/core/widget/search_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/customer_list/controllers/customer_list_controller.dart';

//ignore: must_be_immutable
class CustomerListView extends BaseView<CustomerListController> {
  CustomerListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: 'customer'.tr,
            controller: controller.customerManager.searchTextController.value,
            onSearch: controller.customerManager.searchItemsByNameOnAllItem,
            onMicTap: controller.isSearchSelected.toggle,
            onFilterTap: () {},
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
                  onTap: controller.showAddCustomerModal,
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
          itemCount: controller.customerManager.allItems.value?.length ?? 0,
          controller: controller.customerManager.scrollController,
          padding: const EdgeInsets.only(bottom: 60),
          itemBuilder: (context, index) {
            final element = controller.customerManager.allItems.value![index];

            return InkWell(
              onTap: () async {},
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: index.isEven
                      ? colors.evenListColor
                      : colors.oddListColor,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: Column(
                  children: [
                    Text(element.name ?? ''),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

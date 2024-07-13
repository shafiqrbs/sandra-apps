import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/search_button.dart';
import '/app/global_widget/vendor_card_view.dart';
import '/app/routes/app_pages.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/domain/vendor/vendor_list/controllers/vendor_list_controller.dart';

//ignore: must_be_immutable
class VendorListView extends BaseView<VendorListController> {
  VendorListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryBaseColor,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.vendorList,
            controller: controller.vendorManager.searchTextController.value,
            onSearch: controller.vendorManager.searchItemsByNameOnAllItem,
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
                  onTap: controller.showAddVendorModal,
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
          itemCount: controller.vendorManager.allItems.value?.length ?? 0,
          controller: controller.vendorManager.scrollController,
          padding: const EdgeInsets.only(bottom: 60),
          itemBuilder: (context, index) {
            final element = controller.vendorManager.allItems.value![index];
            return VendorCardView(
              data: element,
              index: index,
              onTap: () {
                Get.toNamed(
                  Routes.customerDetails,
                  arguments: {
                    'vendor': element,
                  },
                );
              },
              onReceive: () {},
              showReceiveButton: true,
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/common_text.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/app_bar_search_view.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/search_button.dart';
import '/app/global_widget/vendor_card_view.dart';
import '/app/pages/domain/vendor/vendor_list/controllers/vendor_list_controller.dart';
import '/app/routes/app_pages.dart';

//ignore: must_be_immutable
class VendorListView extends BaseView<VendorListController> {
  VendorListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.vendors,
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
                  Routes.vendorLedger,
                  arguments: {
                    'vendor': element,
                  },
                );
              },
              onReceive: () async {
                await controller.showVendorPaymentModal(element);
              },
              showReceiveButton: true,
            );
          },
        );
      },
    );
  }

  @override
  Widget floatingActionButton() {
    return Visibility(
      visible: controller.isRoleAccountPayment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: InkWell(
          onTap: () => controller.showVendorPaymentModal(null),
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
                  TablerIcons.plus,
                  color: colors.whiteColor,
                  size: 18,
                ),
                8.width,
                CommonText(
                  text: appLocalization.payment,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  FloatingActionButtonLocation? floatingActionButtonLocation() {
    return FloatingActionButtonLocation.endFloat;
  }
}

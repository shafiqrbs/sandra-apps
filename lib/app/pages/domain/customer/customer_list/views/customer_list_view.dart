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
import '/app/global_widget/customer_card_view.dart';
import '/app/pages/domain/customer/customer_list/controllers/customer_list_controller.dart';
import '/app/routes/app_pages.dart';

//ignore: must_be_immutable
class CustomerListView extends BaseView<CustomerListController> {
  CustomerListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.customerList,
            controller: controller.customerManager.searchTextController.value,
            onSearch: controller.customerManager.searchItemsByNameOnAllItem,
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
            return CustomerCardView(
              data: element,
              index: index,
              onTap: () {
                Get.toNamed(
                  Routes.customerLedger,
                  arguments: {
                    'customer': element,
                  },
                );
              },
              onReceive: () async {
                await controller.showCustomerReceiveModal(
                  element,
                );
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
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: InkWell(
        onTap: ()=>controller.showCustomerReceiveModal(null),
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
                text: appLocalization.receive,
                textColor: Colors.white,
              ),
            ],
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

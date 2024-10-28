import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/app_bar_button_group.dart';
import 'package:sandra/app/core/widget/app_bar_search_view.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
import 'package:sandra/app/core/widget/search_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/domain/user_list_page/controllers/user_list_page_controller.dart';

//ignore: must_be_immutable
class UserListPageView extends BaseView<UserListPageController> {
  UserListPageView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.userList,
            controller: controller.userManager.searchTextController.value,
            onSearch: controller.searchByName,
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
          itemCount: controller.userManager.allItems.value?.length ?? 0,
          controller: controller.userManager.scrollController,
          padding: const EdgeInsets.only(bottom: 60),
          itemBuilder: (context, index) {
            final element = controller.userManager.allItems.value![index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    containerBorderRadius,
                  ),
                  border: Border.all(
                    color: index.isEven
                        ? colors.secondaryColor100
                        : colors.primaryColor100,
                  ),
                  color: index.isEven
                      ? colors.secondaryColor50
                      : colors.primaryColor50,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${index + 1}. ${element.username ?? ''}',
                                style: TextStyle(
                                  fontSize: mediumTFSize,
                                  color: colors.solidBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${element.fullName ?? ''}',
                                style: TextStyle(
                                  fontSize: mediumTFSize,
                                  color: colors.solidBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                ' ${element.email ?? ''}',
                                style: TextStyle(
                                  fontSize: mediumTFSize,
                                  color: colors.solidBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

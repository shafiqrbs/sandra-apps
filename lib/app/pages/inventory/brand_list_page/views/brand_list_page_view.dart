import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/add_button.dart';
import 'package:sandra/app/core/widget/app_bar_button_group.dart';
import 'package:sandra/app/core/widget/app_bar_search_view.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
import 'package:sandra/app/core/widget/search_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/brand_list_page/controllers/brand_list_page_controller.dart';

//ignore: must_be_immutable
class BrandListPageView extends BaseView<BrandListPageController> {
  BrandListPageView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Obx(
        () {
          return AppBarSearchView(
            pageTitle: appLocalization.brandList,
            controller: controller.brandManager.searchTextController.value,
            onSearch: controller.brandManager.searchItemsByNameOnAllItem,
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
                  onTap: controller.onAddBrand,
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
          itemCount: controller.brandManager.allItems.value?.length ?? 0,
          controller: controller.brandManager.scrollController,
          padding: const EdgeInsets.only(bottom: 60),
          itemBuilder: (context, index) {
            final element = controller.brandManager.allItems.value![index];
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 2,
                      left: 16,
                      right: 16,
                      top: 2,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: index.isEven
                            ? colors.secondaryColor50
                            : colors.primaryColor50,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 12, 16),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          element.name ?? '',
                                          style: TextStyle(
                                            fontSize: mediumTFSize,
                                            color: colors.solidBlackColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    16.width,
                                    const Icon(
                                      TablerIcons.chevron_right,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primaryColor100.withOpacity(.5),
                      ),
                      //padding: const EdgeInsets.all(8),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: smallTFSize,
                          color: colors.solidBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

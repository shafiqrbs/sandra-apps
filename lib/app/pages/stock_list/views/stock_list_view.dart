import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/app_bar_button_group.dart';
import 'package:getx_template/app/core/widget/common_text.dart';
import 'package:getx_template/app/core/widget/filter_button.dart';
import 'package:getx_template/app/core/widget/quick_navigation_button.dart';
import 'package:getx_template/app/core/widget/search_button.dart';
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
          return controller.isSearchSelected.value
              ? Container(
                  margin: const EdgeInsets.only(left: 2),
                  height: textFieldHeight,
                  // width: Get.width,
                  decoration: BoxDecoration(
                    color: colors.backgroundColor,
                    borderRadius: BorderRadius.circular(
                      containerBorderRadius,
                    ),
                  ),
                  child: TextFormField(
                    controller:
                        controller.stockManager.searchTextController.value,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: colors.primaryTextColor,
                    ),
                    cursorColor: colors.formCursorColor,
                    onChanged:
                        controller.stockManager.searchItemsByNameOnAllItem,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        TablerIcons.search,
                        color: colors.primaryBaseColor,
                        size: 18,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: controller.isSearchSelected.toggle,
                            icon: Icon(
                              TablerIcons.microphone,
                              color: colors.primaryBaseColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.showFilterModal(
                              context: globalKey.currentContext!,
                            ),
                            icon: Icon(
                              TablerIcons.filter,
                              color: colors.primaryBaseColor.withOpacity(.5),
                            ),
                          ),
                          IconButton(
                            onPressed: controller.isSearchSelected.toggle,
                            icon: Icon(
                              TablerIcons.x,
                              color: Colors.grey.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ), // Adjust the padding as needed
                      hintText: 'hint'.tr,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(.5),
                      ), // Optional hint text
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          4,
                        ),
                        // Adjust the border radius as needed
                        borderSide: const BorderSide(color: Color(0xFFece2d9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Color(0xFFf5edeb),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Color(0xFFf5edeb),
                        ),
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    CommonText(text: 'stock_list'.tr),
                  ],
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
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/base/base_widget.dart';
import 'package:getx_template/app/routes/app_pages.dart';

import 'app_bar_button.dart';
import 'tbd_round_button.dart';

class QuickNavigationButton extends BaseWidget {
  QuickNavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      buttonName: null,
      onTap: () => showQuickNavigateBottomSheet(
        context: context,
      ),
      leftIcon: TablerIcons.library_plus,
      buttonBGColor: colors.tertiaryLiteColor,
      iconColor: colors.primaryBaseColor,
    );
  }

  void showQuickNavigateBottomSheet({
    required BuildContext context,
  }) {
    final animationStyle = AnimationStyle(
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(seconds: 1),
    );
    showModalBottomSheet<void>(
      context: context,
      sheetAnimationStyle: animationStyle,
      builder: (BuildContext context) {
        return SizedBox.expand(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal bottom sheet'),
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                ),
                Wrap(
                  spacing: 8,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  runSpacing: 8,
                  children: [
                    TbdRoundButton(
                      text: 'pos',
                      icon: TablerIcons.garden_cart,
                      onTap: () => navigatePage(Routes.createSales),
                    ),
                    TbdRoundButton(
                      text: 'sales_list',
                      icon: TablerIcons.point_off,
                      onTap: () => navigatePage(Routes.salesList),
                    ),
                    TbdRoundButton(
                      text: 'stock',
                      icon: TablerIcons.shopping_cart,
                      onTap: () => navigatePage(Routes.stockList),
                    ),
                    TbdRoundButton(
                      text: 'add_purchase',
                      icon: TablerIcons.shopping_cart,
                      onTap: () {},
                    ),
                    TbdRoundButton(
                      text: 'purchase_return'.tr,
                      icon: TablerIcons.credit_card,
                      onTap: () {},
                    ),
                    TbdRoundButton(
                      text: 'vendor',
                      icon: TablerIcons.credit_card,
                      onTap: () {},
                    ),
                    TbdRoundButton(
                      text: 'stock_item',
                      icon: TablerIcons.credit_card,
                      onTap: () {},
                    ),
                    TbdRoundButton(
                      text: 'category',
                      icon: TablerIcons.credit_card,
                      onTap: () {},
                    ),
                    TbdRoundButton(
                      text: 'stock_adjustment'.tr,
                      icon: TablerIcons.credit_card,
                      onTap: () {},
                    ),
                    TbdRoundButton(
                      text: 'expense'.tr,
                      icon: TablerIcons.color_swatch,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void navigatePage(String routeName) {
    if (Get.currentRoute != routeName) {
      Get
        ..back()
        ..offNamed(routeName);
    } else {
      Get
        ..back()
        ..back()
        ..toNamed(routeName);
    }
  }
}

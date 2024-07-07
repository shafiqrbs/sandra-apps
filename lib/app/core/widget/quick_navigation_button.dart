import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/base/base_widget.dart';
import '/app/routes/app_pages.dart';

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
      leftIcon: TablerIcons.grid_dots,
      buttonBGColor: Colors.transparent,
      iconColor: Colors.white,
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
                  children: buttonList,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<Widget> buttonList = [
  TbdRoundButton(
    text: 'create_sales',
    icon: TablerIcons.sort_ascending_letters,
    onTap: () => navigatePage(Routes.createSales),
  ),
  TbdRoundButton(
    text: 'sales_list',
    icon: TablerIcons.point_off,
    onTap: () => navigatePage(Routes.salesList),
  ),
  TbdRoundButton(
    text: 'stock_list',
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.stockList),
  ),
  TbdRoundButton(
    text: 'customer_list',
    icon: TablerIcons.robot_face,
    onTap: () => navigatePage(Routes.customerList),
  ),
  TbdRoundButton(
    text: 'create_purchase'.tr,
    icon: TablerIcons.shopping_bag,
    onTap: () => navigatePage(Routes.createPurchase),
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
];
void navigatePage(String routeName) {
  final currentRoute = Get.currentRoute;

  if (currentRoute == Routes.dashboard) {
    // Navigate directly if on the dashboard
    Get.toNamed(routeName);
  } else if (currentRoute != routeName) {
    // If not already on the desired route, navigate to it
    Get
      ..back()
      ..offNamed(routeName);
  } else {
    // If already on the desired route, go back twice then navigate
    Get
      ..back()
      ..back()
      ..toNamed(routeName);
  }
}

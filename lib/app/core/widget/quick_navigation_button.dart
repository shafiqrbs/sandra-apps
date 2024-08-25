import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/prefs_settings_modal/prefs_settings_modal_view.dart';
import '/app/global_modal/sync_modal/sync_modal_view.dart';
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
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
    );
    showModalBottomSheet<void>(
      context: context,
      sheetAnimationStyle: animationStyle,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 4,
            right: 4,
            top: 16,
            bottom: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Text(
                      appLocalization.quickNavigation,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: Get.back,
                    child: const Icon(
                      TablerIcons.x,
                      size: 30,
                    ),
                  ),
                ],
              ),
              16.height,
              Wrap(
                spacing: 4,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                runSpacing: 8,
                children: buttonList,
              ),
            ],
          ),
        );
      },
    );
  }
}

AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

List<Widget> buttonList = [
  TbdRoundButton(
    text: appLocalization.createSales,
    icon: TablerIcons.sort_ascending_letters,
    onTap: () => navigatePage(Routes.createSales),
    localeMethod: () => appLocalization.createSales,
    bgColor: const Color(0xff1E90FF),
  ),
  TbdRoundButton(
    text: appLocalization.salesList,
    icon: TablerIcons.point_off,
    onTap: () => navigatePage(Routes.salesList),
    localeMethod: () => appLocalization.salesList,
    bgColor: const Color(0xff004D40),
  ),
  TbdRoundButton(
    text: appLocalization.stockList,
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.stockList),
    localeMethod: () => appLocalization.stockList,
    bgColor: const Color(0xffFF6F61),
  ),
  TbdRoundButton(
    icon: TablerIcons.robot_face,
    onTap: () => navigatePage(Routes.customerList),
    localeMethod: () => appLocalization.customerList,
    bgColor: const Color(0xff32CD32),
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_bag,
    onTap: () => navigatePage(Routes.createPurchase),
    localeMethod: () => appLocalization.createPurchase,
    bgColor: const Color(0xff4CBB17),
  ),
  TbdRoundButton(
    icon: TablerIcons.butterfly,
    onTap: () => navigatePage(Routes.vendorList),
    localeMethod: () => appLocalization.vendorList,
    bgColor: const Color(0xff5D6D7E),
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () => navigatePage(Routes.purchaseList),
    localeMethod: () => appLocalization.purchaseList,
    bgColor: const Color(0xff6D28D9),
  ),
  TbdRoundButton(
    icon: TablerIcons.list,
    onTap: () => navigatePage(Routes.expenseList),
    localeMethod: () => appLocalization.expenseList,
    bgColor: const Color(0xff1E90FF),
  ),
  TbdRoundButton(
    icon: TablerIcons.credit_card,
    onTap: () => navigatePage(Routes.particular),
    localeMethod: () => appLocalization.particular,
    bgColor: const Color(0xff004D40),
  ),
  TbdRoundButton(
    icon: TablerIcons.loader,
    onTap: () {
      Get.dialog(
        DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: SyncModalView(),
        ),
      );
    },
    localeMethod: () => appLocalization.sync,
    bgColor: const Color(0xffFF6F61),
  ),
  TbdRoundButton(
    icon: TablerIcons.shopping_cart,
    onTap: () {
      Get.dialog(
        DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: PrefsSettingsModalView(),
        ),
      );
    },
    localeMethod: () => appLocalization.settings,
    bgColor: const Color(0xff32CD32),
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

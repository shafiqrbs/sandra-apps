import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/global_modal/add_expense_modal/add_expense_view.dart';
import '/app/core/widget/asset_image_view.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/global_modal/prefs_settings_modal/prefs_settings_modal_view.dart';
import '/app/global_modal/sync_modal/sync_modal_view.dart';
import '/app/routes/app_pages.dart';
import 'app_bar_button.dart';
import 'tbd_round_button.dart';

ValueNotifier<Map<String, Color>> colorList = ValueNotifier(
  {
    'blue': ColorSchema().solidBlueColor,
    'green': ColorSchema().solidGreenColor,
    'red': ColorSchema().solidRedColor,
    'yellow': ColorSchema().solidYellowColor,
    'grey': ColorSchema().solidGreyColor,
    'purple': ColorSchema().solidPurpleColor,
    'orange': ColorSchema().solidOrangeColor,
    'olive': ColorSchema().solidOliveColor,
    'marun': ColorSchema().solidMarunColor,
    'navyBlue': ColorSchema().solidNavyBlueColor,
  },
);

class QuickNavigationButton extends BaseWidget {
  QuickNavigationButton({super.key});

  List<Widget> inventoryButtonList = [
    TbdRoundButton(
      icon: TablerIcons.shopping_cart,
      onTap: () => navigatePage(Routes.salesList),
      localeMethod: () => appLocalization.sales,
      bgColor: colorList.value['blue'],
    ),
    TbdRoundButton(
      icon: TablerIcons.truck_delivery,
      onTap: () => navigatePage(Routes.purchaseList),
      localeMethod: () => appLocalization.purchase,
      bgColor: colorList.value['orange'],
    ),
    TbdRoundButton(
      icon: TablerIcons.packages,
      onTap: () => navigatePage(Routes.stockList),
      localeMethod: () => appLocalization.stocks,
      bgColor: colorList.value['green'],
    ),
    TbdRoundButton(
      icon: TablerIcons.credit_card_refund,
      onTap: () {
        showSnackBar(
          type: SnackBarType.warning,
          title: appLocalization.upcomingFeature,
          message: appLocalization.comingSoon,
        );
      },
      localeMethod: () => appLocalization.salesReturn,
      bgColor: colorList.value['navyBlue'],
    ),
    TbdRoundButton(
      icon: TablerIcons.users_group,
      onTap: () => navigatePage(Routes.customerList),
      localeMethod: () => appLocalization.customer,
      bgColor: colorList.value['purple'],
    ),
    TbdRoundButton(
      icon: TablerIcons.building_store,
      onTap: () => navigatePage(Routes.vendorList),
      localeMethod: () => appLocalization.vendor,
      bgColor: colorList.value['olive'],
    ),
    TbdRoundButton(
      text: appLocalization.stockList,
      icon: TablerIcons.receipt_refund,
      onTap: () {
        showSnackBar(
          type: SnackBarType.warning,
          title: appLocalization.upcomingFeature,
          message: appLocalization.comingSoon,
        );
      },
      localeMethod: () => appLocalization.purchaseReturn,
      bgColor: colorList.value['red'],
    ),
  ];

  List<Widget> accountingButtonList = [
    TbdRoundButton(
      icon: TablerIcons.wallet,
      onTap: () async {
        await Get.dialog(
          DialogPattern(
            title: appLocalization.createExpense,
            subTitle: appLocalization.createExpenseDetails,
            child: AddExpenseView(),
          ),
        );
      },
      localeMethod: () => appLocalization.newExpense,
      bgColor: colorList.value['marun'],
    ),
    TbdRoundButton(
      icon: TablerIcons.exposure,
      onTap: () => navigatePage(Routes.expenseList),
      localeMethod: () => appLocalization.expense,
      bgColor: colorList.value['grey'],
    ),
    TbdRoundButton(
      icon: TablerIcons.shopping_cart,
      onTap: () => navigatePage(Routes.accountingSales),
      localeMethod: () => appLocalization.sales,
      bgColor: colorList.value['blue'],
    ),
    TbdRoundButton(
      icon: TablerIcons.users_group,
      onTap: () => navigatePage(Routes.customerList),
      localeMethod: () => appLocalization.customer,
      bgColor: colorList.value['purple'],
    ),
    TbdRoundButton(
      icon: TablerIcons.truck_delivery,
      onTap: () => navigatePage(Routes.accountingPurchase),
      localeMethod: () => appLocalization.purchase,
      bgColor: colorList.value['orange'],
    ),
    TbdRoundButton(
      icon: TablerIcons.building_store,
      onTap: () => navigatePage(Routes.vendorList),
      localeMethod: () => appLocalization.vendor,
      bgColor: colorList.value['olive'],
    ),
    TbdRoundButton(
      icon: TablerIcons.report,
      onTap: () {
        showSnackBar(
          type: SnackBarType.warning,
          title: appLocalization.upcomingFeature,
          message: appLocalization.comingSoon,
        );
      },
      localeMethod: () => appLocalization.journal,
      bgColor: colorList.value['red'],
    ),
  ];

  List<Widget> configButtonList = [
    TbdRoundButton(
      icon: TablerIcons.settings_2,
      onTap: () => navigatePage(Routes.settings),
      localeMethod: () => appLocalization.global,
      bgColor: colorList.value['green'],
    ),
    TbdRoundButton(
      icon: TablerIcons.database_cog,
      onTap: () {
        Get.dialog(
          DialogPattern(
            title: appLocalization.inventorySettings,
            subTitle: '',
            child: PrefsSettingsModalView(),
          ),
        );
      },
      localeMethod: () => appLocalization.inventory,
      bgColor: colorList.value['navyBlue'],
    ),
    TbdRoundButton(
      icon: TablerIcons.rotate_rectangle,
      onTap: () {
        Get.dialog(
          DialogPattern(
            title: appLocalization.synchronization,
            subTitle: appLocalization.importDataToEnsureEverythingIsUpToDate,
            child: SyncModalView(),
          ),
        );
      },
      localeMethod: () => appLocalization.sync,
      bgColor: colorList.value['marun'],
    ),
    TbdRoundButton(
      icon: TablerIcons.refresh_dot,
      onTap: () => navigatePage(Routes.offlineSyncProcess),
      localeMethod: () => appLocalization.offlineSyncProcess,
      bgColor: colorList.value['olive'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showQuickNavigateBottomSheet(context: context),
      child: const AssetImageView(
        width: 32,
        height: 32,
        fileName: 'ic_menu.svg',
      ),
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: Get.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              top: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 6,
                        right: 16,
                      ),
                      child: Text(
                        appLocalization.quickNavigation,
                        textAlign: TextAlign.left,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        16.height,
                        /*Wrap(
                          spacing: 4,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          runSpacing: 8,
                          children: buttonList,
                        ),*/
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: startCAA,
                            children: [
                              CommonText(
                                text: appLocalization.accounting,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              dividerWidget(),
                              16.height,
                              Wrap(
                                spacing: 4,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                runSpacing: 8,
                                children: accountingButtonList,
                              ),
                              CommonText(
                                text: appLocalization.inventory,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              dividerWidget(),
                              16.height,
                              Wrap(
                                spacing: 4,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                runSpacing: 8,
                                children: inventoryButtonList,
                              ),
                              CommonText(
                                text: appLocalization.configuration,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              dividerWidget(),
                              16.height,
                              Wrap(
                                spacing: 4,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                runSpacing: 8,
                                children: configButtonList,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dividerWidget() {
    return Divider(
      color: colors.secondaryColor50,
      thickness: 1,
    );
  }
}

AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/utils/test_functions.dart';
import 'package:sandra/app/core/widget/tbd_round_button.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/widget/tbd_text_button.dart';
import '/app/core/widget/title_subtitle_button.dart';
import '/app/pages/dashboard/controllers/dashboard_controller.dart';

//ignore: must_be_immutable
class DashboardView extends BaseView<DashboardController> {
  DashboardView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: AppBar().preferredSize.height + Get.height * .071,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: colors.primaryBaseColor,
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonText(
                      text: 'store_name'.tr,
                      fontSize: headerTFSize,
                      fontWeight: FontWeight.w500,
                      textColor: colors.backgroundColor,
                    ),
                  ),
                  Expanded(
                    child: CommonText(
                      text: 'user_name'.tr,
                      fontSize: regularTFSize,
                      fontWeight: FontWeight.normal,
                      textColor: colors.backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              appLocalization.home,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              appLocalization.settings,
            ),
            onTap: controller.goToSettings,
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: startMAA,
      crossAxisAlignment: endCAA,
      children: [
        _buildTopBar(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  1.height,
                  _buildDashboard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      height: AppBar().preferredSize.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.primaryBaseColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appLocalization.dashboard,
            style: TextStyle(
              color: colors.backgroundColor,
              fontSize: regularTFSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () {
                  return CommonText(
                    text: controller.isOnline.value
                        ? appLocalization.online
                        : appLocalization.offline,
                    fontSize: 10,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w400,
                  );
                },
              ),
              4.width,

              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Obx(
                    () {
                      return GestureDetector(
                        onTap: controller.onTapIsOnline,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: controller.isOnline.value
                                ? colors.successButtonBorderColor
                                : colors.dangerBaseColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              12.width,
              InkWell(
                onTap: () {},
                child: const Icon(
                  TablerIcons.clipboard_text,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              12.width,
              InkWell(
                onTap: () {},
                child: const Icon(
                  TablerIcons.dots_vertical,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              // GlobalThreeDotMenu(isAddOption: false,)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Column(
      children: [
        12.height,
        _buildThreeCommonButtons(),
        _buildBalanceList(),
        16.height,
        _buildTitleSubTitleButtonList(),
        14.height,
        _buildButtons(),
      ],
    );
  }

  Widget _buildBalanceList() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xffF7EDE9),
      ),
      child: Row(
        children: [
          _buildBalanceCard(
            onTap: controller.cashOnTap,
            title: appLocalization.cash,
            amount: '৳ 567',
          ),
          8.width,
          _buildBalanceCard(
            onTap: controller.bankOnTap,
            title: appLocalization.bank,
            amount: '৳ 567',
          ),
          8.width,
          _buildBalanceCard(
            onTap: controller.mobileOnTap,
            title: appLocalization.mobile,
            amount: '৳ 567',
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard({
    final String title = 'Title',
    final String amount = 'Subtitle',
    final Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: startCAA,
            children: [
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  CommonText(
                    text: title,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: colors.primaryTextColor,
                  ),
                  6.width,
                  const Icon(
                    TablerIcons.chevron_right,
                    color: Color(0xff202020),
                    size: 16,
                  ),
                ],
              ),
              CommonText(
                text: amount,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textColor: const Color(0xff202020),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSubTitleButtonList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: spaceBetweenMAA,
            children: [
              TitleSubtitleButton(
                title: appLocalization.sales,
                subTitle: '৳ 567',
                icon: TablerIcons.report_analytics,
                onTap: controller.goToSalesList,
                bgColor: colors.solidBlueColor,
              ),
              10.width,
              TitleSubtitleButton(
                title: appLocalization.purchase,
                subTitle: '৳ 567',
                icon: TablerIcons.cash,
                onTap: controller.goToPurchaseList,
                bgColor: colors.solidGreenColor,
              ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: spaceBetweenMAA,
            children: [
              TitleSubtitleButton(
                title: appLocalization.due,
                subTitle: '৳ 567',
                icon: TablerIcons.cash,
                onTap: controller.goToDueCustomerList,
                bgColor: colors.solidRedColor,
              ),
              10.width,
              TitleSubtitleButton(
                title: appLocalization.expense,
                subTitle: '৳ 567',
                icon: TablerIcons.moneybag,
                onTap: controller.goToExpenseList,
                bgColor: colors.solidLiteGreenColor,
              ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: spaceBetweenMAA,
            children: [
              TitleSubtitleButton(
                title: appLocalization.logout,
                subTitle: '৳ 567',
                icon: TablerIcons.moneybag,
                onTap: controller.logOut,
                bgColor: const Color(0xff4CBB17),
              ),
              10.width,
              if (kDebugMode)
                TitleSubtitleButton(
                  title: 'Clear License',
                  subTitle: '৳ 567',
                  icon: TablerIcons.moneybag,
                  onTap: controller.clearLicense,
                  bgColor: const Color(0xff4CBB17),
                ),
              if (kReleaseMode)
                Expanded(
                  child: Container(),
                ),
            ],
          ),
          if (kDebugMode) _buildTestData(),
        ],
      ),
    );
  }

  Widget _buildThreeCommonButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.primaryLiteColor.withOpacity(.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          _buildCommonButtonCard(
            title: appLocalization.pos,
            buttonColor: colors.solidBlueColor,
            onTap: controller.goToSales,
          ),
          _buildCommonButtonCard(
            title: appLocalization.po,
            buttonColor: colors.solidGreenColor,
            onTap: controller.goToPo,
          ),
          _buildCommonButtonCard(
            title: appLocalization.receive,
            buttonColor: colors.solidGreyColor,
            onTap: controller.showCustomerReceiveModal,
          ),
          _buildCommonButtonCard(
            title: appLocalization.pay,
            buttonColor: colors.solidRedColor,
            onTap: controller.showVendorPaymentModal,
          ),
        ],
      ),
    );
  }

  Widget _buildCommonButtonCard({
    required String title,
    required Color buttonColor,
    required Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(
            right: 4,
            left: 4,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: CommonText(
            text: title,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Obx(
      () {
        return Column(
          children: [
            _buildButtonGroup(),
            24.height,
            Wrap(
              spacing: 18,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              runSpacing: 16,
              children: controller.dashboardButtonList,
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonGroup() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: const BoxDecoration(
        color: Color(0xffF7EDE9),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        child: Row(
          children: [
            TbdTextButton(
              selectedBgColor: colors.primaryBaseColor,
              text: appLocalization.inventory,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.inventory,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.inventory,
            ),
            TbdTextButton(
              selectedBgColor: colors.primaryBaseColor,
              text: appLocalization.accounting,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.accounting,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.accounting,
            ),
            TbdTextButton(
              selectedBgColor: colors.primaryBaseColor,
              text: appLocalization.create,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.create,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.create,
            ),
            TbdTextButton(
              selectedBgColor: colors.primaryBaseColor,
              text: appLocalization.config,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.config,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.config,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestData() {
    return Column(
      children: [
        10.height,
        Row(
          children: [
            TbdTextButton(
              onPressed: () => controller.generateDummySales(),
              text: 'Generate Sales',
              isSelected: true,
            ),
            10.width,
            TbdTextButton(
              onPressed: () => controller.generateDummySales(
                isHold: 1,
              ),
              text: 'Generate Hold  Sales',
              isSelected: true,
            ),
          ],
        ),
        10.height,
        Row(
          children: [
            TbdTextButton(
              onPressed: () => controller.generateDummyPurchase(),
              text: 'Generate Purchase',
              isSelected: true,
            ),
            10.width,
            TbdTextButton(
              onPressed: () => controller.generateDummyPurchase(
                isHold: 1,
              ),
              text: 'Generate Hold  Purcha',
              isSelected: true,
            ),
          ],
        ),
        10.height,
        Row(
          children: [
            const TbdTextButton(
              onPressed: clearSalesTable,
              text: 'Clear Sales',
              isSelected: true,
            ),
            10.width,
            const TbdTextButton(
              onPressed: clearSPurchaseTable,
              text: 'Clear Purchase',
              isSelected: true,
            ),
          ],
        ),
        10.height,
      ],
    );
  }
}

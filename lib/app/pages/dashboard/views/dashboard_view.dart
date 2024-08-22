import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;
import 'package:sandra/app/core/widget/custom_animation_widget.dart';

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
                  //_buildTabSelection(),
                  /*Obx(
                    () {
                      final selectedTab = controller.selectedTab.value;
                      return selectedTab == SelectedTab.dashboard
                          ? _buildDashboard()
                          : _buildReport();
                    },
                  ),*/
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
            'dashboard'.tr,
            style: TextStyle(
              color: colors.backgroundColor,
              fontSize: regularTFSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                text: 'online'.tr,
                fontSize: 10,
                textColor: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              4.width,
              Obx(
                () {
                  return AdvancedSwitch(
                    activeColor: Colors.white,
                    inactiveColor: const Color(0xFFE9E9E9),
                    borderRadius: BorderRadius.circular(
                      containerBorderRadius,
                    ),
                    width: 30,
                    height: 16,
                    controller: controller.showOnlineController.value,
                  );
                },
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

  Widget _buildTabSelection() {
    return Obx(
      () {
        return Row(
          children: [
            TbdTextButton(
              text: appLocalization.dashboard,
              onPressed: () => controller.changeTab(SelectedTab.dashboard),
              isSelected: controller.selectedTab.value == SelectedTab.dashboard,
            ),
            TbdTextButton(
              text: appLocalization.report,
              onPressed: () => controller.changeTab(SelectedTab.report),
              isSelected: controller.selectedTab.value == SelectedTab.report,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboard() {
    return Column(
      children: [
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
      decoration: BoxDecoration(
        color: colors.primaryBaseColor.withOpacity(.5),
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
                bgColor: const Color(0xff1E90FF),
              ),
              10.width,
              TitleSubtitleButton(
                title: appLocalization.purchase,
                subTitle: '৳ 567',
                icon: TablerIcons.cash,
                onTap: () {
                  //Get.to(PurchaseScreen());
                },
                bgColor: const Color(0xff004D40),
              ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: spaceBetweenMAA,
            children: [
              TitleSubtitleButton(
                title: appLocalization.expense,
                subTitle: '৳ 567',
                icon: TablerIcons.moneybag,
                onTap: () {
                  //Get.to(PurchaseScreen());
                },
                bgColor: const Color(0xff4CBB17),
              ),
              10.width,
              TitleSubtitleButton(
                title: appLocalization.due,
                subTitle: '৳ 567',
                icon: TablerIcons.cash,
                onTap: () {
                  //Get.to(PurchaseScreen());
                },
                bgColor: const Color(0xffFF6F61),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return DecoratedBox(
      //padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          16.height,
          Row(
            children: [
              Expanded(
                child: _buildTitleSubTitle(
                  title: appLocalization.sales,
                  subTitle: '567',
                ),
              ),
              Container(
                height: 60,
                width: 1,
                color: const Color(0xffbababa),
              ),
              Expanded(
                child: _buildTitleSubTitle(
                  title: appLocalization.purchase,
                  subTitle: '567',
                ),
              ),
              Container(
                height: 60,
                width: 1,
                color: const Color(0xffbababa),
              ),
              Expanded(
                child: _buildTitleSubTitle(
                  title: 'due',
                  subTitle: '567',
                ),
              ),
            ],
          ),
          16.height,
          const Divider(
            color: Color(0xffe9e9e9),
          ),
          16.height,
          const pie_chart.PieChart(
            dataMap: {
              'Sales': 5,
              'Purchase': 3,
              'Due': 2,
            },
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 20,
            chartRadius: 100,
            colorList: [
              Color(0xff989898),
              Color(0xff4d4d4d),
              Color(0xff202020),
            ],
            initialAngleInDegree: 0,
            chartType: pie_chart.ChartType.ring,
            ringStrokeWidth: 10,
            centerText: '',
            legendOptions: pie_chart.LegendOptions(
              legendPosition: pie_chart.LegendPosition.bottom,
              showLegendsInRow: true,
            ),
          ),
          16.height,
        ],
      ),
    );
  }

  Widget _buildTitleSubTitle({
    final String title = 'Title',
    final String subTitle = 'Subtitle',
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: startMAA,
        crossAxisAlignment: startCAA,
        children: [
          Text(
            title.tr,
            style: GoogleFonts.inter(
              color: const Color(0xff4d4d4d),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          2.height,
          Text(
            subTitle,
            style: GoogleFonts.roboto(
              color: const Color(0xff202020),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
            CustomAnimationWidget(
              leftPosition: true,
              child: Wrap(
                spacing: 18,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                runSpacing: 16,
                children: controller.dashboardButtonList,
              ),
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
      child: Row(
        children: [
          TbdTextButton(
            text: appLocalization.inventory,
            onPressed: () => controller.updateSelectedButtonGroup(
              SelectedButtonGroup.inventory,
            ),
            isSelected: controller.selectedButtonGroup.value ==
                SelectedButtonGroup.inventory,
          ),
          TbdTextButton(
            text: appLocalization.accounting,
            onPressed: () => controller.updateSelectedButtonGroup(
              SelectedButtonGroup.accounting,
            ),
            isSelected: controller.selectedButtonGroup.value ==
                SelectedButtonGroup.accounting,
          ),
          TbdTextButton(
            text: appLocalization.config,
            onPressed: () => controller.updateSelectedButtonGroup(
              SelectedButtonGroup.config,
            ),
            isSelected: controller.selectedButtonGroup.value ==
                SelectedButtonGroup.config,
          ),
        ],
      ),
    );
  }
}

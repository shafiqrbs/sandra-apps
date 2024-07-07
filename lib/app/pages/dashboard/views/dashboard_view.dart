import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/widget/common_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;

import '/app/core/base/base_view.dart';
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
            title: Text('home'.tr),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('settings'.tr),
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
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  10.height,
                  _buildTabSelection(),
                  Obx(
                    () {
                      final selectedTab = controller.selectedTab.value;
                      return selectedTab == SelectedTab.dashboard
                          ? _buildDashboard()
                          : _buildReport();
                    },
                  ),
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
      height: AppBar().preferredSize.height,
      width: Get.width,
      decoration: BoxDecoration(
        color: colors.primaryBaseColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  TablerIcons.menu_2,
                  color: Colors.white,
                ),
              );
            },
          ),
          Text(
            'dashboard'.tr,
            style: TextStyle(
              color: colors.backgroundColor,
              fontSize: appBarTFSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(MdiIcons.bell),
                color: Colors.white,
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
              text: 'dashboard'.tr,
              onPressed: () => controller.changeTab(SelectedTab.dashboard),
              isSelected: controller.selectedTab.value == SelectedTab.dashboard,
            ),
            TbdTextButton(
              text: 'report'.tr,
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
        20.height,
        _buildTitleSubTitleButtonList(),
        20.height,
        _buildChart(),
        20.height,
        _buildButtons(),
      ],
    );
  }

  Widget _buildReport() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(),
    );
  }

  Widget _buildTitleSubTitleButtonList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        runSpacing: 8,
        children: [
          TitleSubtitleButton(
            title: 'clear_licence',
            subTitle: '',
            icon: TablerIcons.report_analytics,
            onTap: controller.goToClearLicense,
          ),
          TitleSubtitleButton(
            title: 'sales',
            subTitle: '567',
            icon: TablerIcons.report_analytics,
            onTap: controller.goToSalesList,
          ),
          TitleSubtitleButton(
            title: 'purchase',
            subTitle: '567',
            icon: TablerIcons.cash,
            onTap: () {
              //Get.to(PurchaseScreen());
            },
          ),
          TitleSubtitleButton(
            title: 'expense',
            subTitle: '567',
            icon: TablerIcons.moneybag,
            onTap: () {
              //Get.to(PurchaseScreen());
            },
          ),
          TitleSubtitleButton(
            title: 'profit',
            subTitle: '567',
            icon: TablerIcons.cash,
            onTap: () {
              //Get.to(PurchaseScreen());
            },
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
                  title: 'sales',
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
                  title: 'purchase',
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
    return Column(
      children: [
        _buildButtonGroup(),
        20.height,
        Wrap(
          spacing: 8,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          runSpacing: 8,
          children: buttonList,
        ),
      ],
    );
  }

  Widget _buildButtonGroup() {
    return Row(
      children: [
        TbdTextButton(
          text: 'inventory',
          onPressed: () => controller.selectedButtonGroup.value =
              SelectedButtonGroup.inventory,
          isSelected: controller.selectedButtonGroup.value ==
              SelectedButtonGroup.inventory,
        ),
        TbdTextButton(
          text: 'accounting',
          onPressed: () => controller.selectedButtonGroup.value =
              SelectedButtonGroup.accounting,
          isSelected: controller.selectedButtonGroup.value ==
              SelectedButtonGroup.accounting,
        ),
      ],
    );
  }
}

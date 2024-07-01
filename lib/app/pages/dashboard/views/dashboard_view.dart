import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/tbd_text_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/dashboard/controllers/dashboard_controller.dart';

//ignore: must_be_immutable
class DashboardView extends BaseView<DashboardController> {
  DashboardView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
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
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              TablerIcons.menu_2,
              color: Colors.white,
            ),
          ),
          Text(
            'dashboard'.tr,
            style: TextStyle(
              color: colors.backgroundColor,
              fontSize: dimensions.appBarTFSize,
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
      child: Column(
        children: [],
      ),
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
          _buildTitleSubTitleButton(
            title: 'sales',
            subTitle: '567',
            icon: TablerIcons.report_analytics,
            onTap: controller.goToSales,
          ),
          _buildTitleSubTitleButton(
            title: 'purchase',
            subTitle: '567',
            icon: TablerIcons.cash,
            onTap: () {
              //Get.to(PurchaseScreen());
            },
          ),
          _buildTitleSubTitleButton(
            title: 'expense',
            subTitle: '567',
            icon: TablerIcons.moneybag,
            onTap: () {
              //Get.to(PurchaseScreen());
            },
          ),
          _buildTitleSubTitleButton(
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
            chartValuesOptions: pie_chart.ChartValuesOptions(
              showChartValues: true,
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

  Widget _buildTitleSubTitleButton({
    final String title = 'Title',
    final String subTitle = 'Subtitle',
    final IconData? icon,
    final VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
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
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xffe9e9e9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon ?? TablerIcons.eraser,
                color: const Color(0xff4d4d4d),
                size: 20,
              ),
            ),
            6.height,
            Text(
              title.tr,
              style: GoogleFonts.roboto(
                color: const Color(0xff4d4d4d),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            4.height,
            Text(
              subTitle,
              style: GoogleFonts.roboto(
                color: const Color(0xff4d4d4d),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
          children: [
            TbdRoundButton(
              text: 'pos',
              icon: TablerIcons.garden_cart,
              onTap: mvc.goToSales,
            ),
            TbdRoundButton(
              text: 'sales_list',
              icon: TablerIcons.point_off,
              onTap: mvc.goToSalesList,
            ),
            TbdRoundButton(
              text: 'stock',
              icon: TablerIcons.shopping_cart,
              onTap: mvc.goToStockList,
            ),
            TbdRoundButton(
              text: 'add_purchase',
              icon: TablerIcons.shopping_cart,
              onTap: mvc.gotoPurchaseScreen,
            ),
            TbdRoundButton(
              text: 'purchase_return'.tr,
              icon: TablerIcons.credit_card,
              onTap: () {},
            ),
            TbdRoundButton(
              text: 'vendor',
              icon: TablerIcons.credit_card,
              onTap: () {
                if (Get.isRegistered<ReceiveModalController>()) {
                  Get.delete<ReceiveModalController>();
                }
                showDialog(
                  context: Get.context!,
                  builder: (context) => DialogPattern(
                    title: 'receive'.tr,
                    subTitle: 'payment'.tr,
                    child: ReceiveModalView(
                      customer: null,
                    ),
                  ),
                );
              },
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
              onTap: mvc.gotoExpenseScreen,
            ),
          ],
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: mvc.commonCardView.copyWith(
                  title: 'receive_modal'.tr,
                  subTitle: '567',
                  backgroundColor: colors.colorOne,
                  onTap: () {
                    if (Get.isRegistered<ReceiveModalController>()) {
                      Get.delete<ReceiveModalController>();
                    }
                    showDialog(
                      context: Get.context!,
                      builder: (context) => DialogPattern(
                        title: 'receive'.tr,
                        subTitle: 'payment'.tr,
                        child: ReceiveModalView(
                          customer: null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: mvc.commonCardView.copyWith(
                  backgroundColor: colors.colorTwo,
                  title: 'purchase_screen'.tr,
                  onTap: () {
                    Get.to(PurchaseScreen());
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: mvc.commonCardView.copyWith(
                  title: 'sync_sales'.tr,
                  subTitle: '567',
                  backgroundColor: colors.colorThree,
                  onTap: () async {
                    await newServices.fetchOnlineData(
                      () async {
                        final salesList = await dbHelper.getAll(
                          tbl: tableSale,
                        );

                        final data = await newServices.postSales(
                          shouldShowLoader: true,
                          salesList: salesList,
                          mode: 'offline',
                        );
                        print('Receive Success $data');
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: mvc.commonCardView.copyWith(
                  backgroundColor: colors.colorFour,
                  onTap: () async {
                    await dbHelper.deleteAll(
                      tbl: tableSale,
                    );
                  },
                  title: 'clear_sales_table'.tr,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: mvc.commonCardView.copyWith(
                  title: 'account_sales'.tr,
                  subTitle: '567',
                  backgroundColor: colors.colorFive,
                  onTap: () {
                    Get.to(AccountSalesPage.new);
                  },
                ),
              ),
              Expanded(
                child: mvc.commonCardView.copyWith(
                  title: 'Reset Data',
                  subTitle: '567',
                  backgroundColor: colors.colorSix,
                  onTap: mvc.resetData,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: mvc.commonCardView.copyWith(
                  title: 'change_sales_mode'.tr,
                  subTitle: '567',
                  backgroundColor: colors.colorFive,
                  onTap: () async {
                    await prefs.setIsSalesOnline(
                      isSalesOnline: !(await prefs.getIsSalesOnline()),
                    );
                    print(await prefs.getIsSalesOnline());
                  },
                ),
              ),
              Expanded(
                child: mvc.commonCardView.copyWith(
                  title: 'Dummy Data',
                  subTitle: '567',
                  backgroundColor: colors.colorSix,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonGroup() {
    return Row(
      children: [
        TbdTextButton(
          text: 'inventory',
          onPressed: () =>
              mvc.selectedButtonGroup.value = SelectedButtonGroup.inventory,
          isSelected:
              mvc.selectedButtonGroup.value == SelectedButtonGroup.inventory,
        ),
        TbdTextButton(
          text: 'accounting',
          onPressed: () =>
              mvc.selectedButtonGroup.value = SelectedButtonGroup.accounting,
          isSelected:
              mvc.selectedButtonGroup.value == SelectedButtonGroup.accounting,
        ),
      ],
    );
  }
}

import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/app_values.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/tbd_round_button.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '/app/core/utils/test_functions.dart';
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
                color: colors.solidRedColor,
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonText(
                      text: appLocalization.storeName,
                      fontSize: headerTFSize,
                      fontWeight: FontWeight.w500,
                      textColor: colors.whiteColor,
                    ),
                  ),
                  Expanded(
                    child: CommonText(
                      text: appLocalization.userName,
                      fontSize: regularTFSize,
                      fontWeight: FontWeight.normal,
                      textColor: colors.whiteColor,
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
    return Obx(
      () => Column(
        mainAxisAlignment: startMAA,
        crossAxisAlignment: endCAA,
        children: [
          _buildTopBar(context),
          Expanded(
            child: Padding(
              padding: EdgeInsets.zero,
              child: RefreshIndicator(
                onRefresh: () async {
                  if (controller.isOnline.value) {
                    await controller.fetchOnlineFinancialData();
                  } else {
                    await controller.fetchOfflineFinancialData();
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      1.height,
                      _buildDashboard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        color: colors.primaryColor500,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            SetUp().name ?? '',
            style: TextStyle(
              color: colors.whiteColor,
              fontSize: regularTFSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: controller.onTapIsOnline,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: controller.isOnline.value
                              ? colors.primaryColor800
                              : colors.solidRedColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
                16.width,
                controller.isManager
                    ? GestureDetector(
                        onTap: controller.goToReportList,
                        child: Icon(
                          TablerIcons.report,
                          color: colors.whiteColor,
                          size: 20,
                        ),
                      )
                    : Container(),
                controller.isManager ? 16.width : Container(),

                InkWell(
                  // onTap: controller.changeTheme,
                  child: Icon(
                    Get.isDarkMode ? TablerIcons.sun : TablerIcons.moon,
                    color: colors.whiteColor,
                    size: 20,
                  ),
                ),
                16.width,
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: SuperTooltip(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: controller.logOut,
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: colors.solidBlackColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    arrowTipDistance: 10,
                    arrowLength: 8,
                    arrowBaseWidth: 8,
                    //right: -16,
                    hideTooltipOnTap: true,
                    //elevation: 0,
                    hasShadow: false,
                    backgroundColor: Colors.white,
                    borderRadius: 4,
                    barrierColor: Colors.transparent,
                    child: const Icon(
                      TablerIcons.dots_vertical,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                // GlobalThreeDotMenu(isAddOption: false,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Column(
      children: [
        //if (kDebugMode) _buildThemeSelector(),
        12.height,
        _buildNewUpdateView(),
        _buildThreeCommonButtons(),
        _buildFinancialDataView(),
        14.height,
        _buildButtons(),
      ],
    );
  }

  Widget _buildNewUpdateView() {
    final version = controller.financialData.value?.version;
    if (version == null || version == AppValues.appVersion) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryColor50,
      ),
      child: Row(
        mainAxisAlignment: spaceBetweenMAA,
        children: [
          Column(
            crossAxisAlignment: startCAA,
            children: [
              Text(
                appLocalization.updateAvailable,
                style: AppTextStyle.h2TextStyle600,
              ),
              4.height,
              Text(
                appLocalization.updateStatus,
                style: AppTextStyle.h3TextStyle400,
              ),
            ],
          ),
          GestureDetector(
            onTap: controller.updateApp,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colors.primaryColor500,
              ),
              child: Text(
                appLocalization.update,
                style: AppTextStyle.h2TextStyle600.copyWith(
                  color: colors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceList() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor50,
        //color: Color(0xffF7EDE9),
      ),
      child: Row(
        children: controller.financialData.value?.transactionOverview
                ?.map(
                  (item) => _buildBalanceCard(
                    onTap: () => controller.onTransactionOverviewTap(item),
                    title: item.name ?? '',
                    amount: '${controller.currency} ${item.amount ?? ''}',
                  ),
                )
                .toList() ??
            [],
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
          margin: const EdgeInsets.only(
            right: 8,
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
                    textColor: colors.solidBlackColor,
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
              if (isRoleSales)
                TitleSubtitleButton(
                  title: appLocalization.sales,
                  subTitle:
                      '${controller.currency} ${controller.financialData.value?.sales ?? ''}',
                  icon: TablerIcons.report_analytics,
                  onTap: controller.goToSalesList,
                  bgColor: colors.secondaryBlueColor,
                ),
              10.width,
              if (isRolePurchase)
                TitleSubtitleButton(
                  title: appLocalization.purchase,
                  subTitle:
                      '${controller.currency} ${controller.financialData.value?.purchase ?? ''}',
                  icon: TablerIcons.cash,
                  onTap: controller.goToPurchaseList,
                  bgColor: colors.secondaryOrangeColor,
                ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: spaceBetweenMAA,
            children: [
              if (isRoleSales)
                TitleSubtitleButton(
                  title: appLocalization.due,
                  subTitle:
                      '${controller.currency} ${controller.financialData.value?.due ?? ''}',
                  icon: TablerIcons.cash,
                  onTap: controller.goToDueCustomerList,
                  bgColor: colors.secondaryGreenColor,
                ),
              10.width,
              if (isRoleExpense)
                TitleSubtitleButton(
                  title: appLocalization.expense,
                  subTitle:
                      '${controller.currency} ${controller.financialData.value?.expenditure ?? ''}',
                  icon: TablerIcons.moneybag,
                  onTap: controller.goToExpenseList,
                  bgColor: colors.secondaryGreyColor,
                ),
            ],
          ),
          10.height,
          //  if (kDebugMode) _buildTestData(),
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
        color: colors.primaryColor50,
        //color: Color(0xffF7EDE9),
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
            permission: controller.isRoleSales,
          ),
          _buildCommonButtonCard(
            title: appLocalization.receive,
            buttonColor: colors.solidPurpleColor,
            onTap: controller.showCustomerReceiveModal,
            permission: controller.isRoleAccountReceive,
          ),
          _buildCommonButtonCard(
            title: appLocalization.po,
            buttonColor: colors.solidOrangeColor,
            onTap: controller.goToPo,
            permission: controller.isRolePurchase,
          ),
          _buildCommonButtonCard(
            title: appLocalization.pay,
            buttonColor: colors.solidOliveColor,
            onTap: controller.showVendorPaymentModal,
            permission: controller.isRoleAccountPayment,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialDataView() {
    return Obx(
      () {
        if (controller.financialData.value == null) {
          return Container();
        }
        return Column(
          children: [
            _buildBalanceList(),
            16.height,
            _buildTitleSubTitleButtonList(),
          ],
        );
      },
    );
  }

  Widget _buildCommonButtonCard({
    required String title,
    required Color buttonColor,
    required Function()? onTap,
    required bool permission,
  }) {
    if (!permission) return Container();
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
            horizontal: 8,
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
            maxLine: 1,
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
              children: controller.dashboardButtonList
                  .whereType<TbdRoundButton>()
                  .where((button) => button.permission) // Filters by permission
                  .toList(),
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
      decoration: BoxDecoration(
        color: colors.primaryColor50,
        //color: Color(0xffF7EDE9),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        child: Row(
          children: [
            TbdTextButton(
              flex: 4,
              selectedBgColor: colors.primaryColor300,
              text: appLocalization.inventory,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.inventory,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.inventory,
            ),
            TbdTextButton(
              flex: 5,
              selectedBgColor: colors.primaryColor300,
              text: appLocalization.accounting,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.accounting,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.accounting,
            ),
            TbdTextButton(
              flex: 4,
              selectedBgColor: colors.primaryColor300,
              text: appLocalization.create,
              onPressed: () => controller.updateSelectedButtonGroup(
                SelectedButtonGroup.create,
              ),
              isSelected: controller.selectedButtonGroup.value ==
                  SelectedButtonGroup.create,
            ),
            TbdTextButton(
              flex: 4,
              selectedBgColor: colors.primaryColor300,
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
        Row(
          children: [
            TbdTextButton(
              onPressed: controller.goToRestaurantHome,
              text: 'Restaurant Module',
              isSelected: true,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
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

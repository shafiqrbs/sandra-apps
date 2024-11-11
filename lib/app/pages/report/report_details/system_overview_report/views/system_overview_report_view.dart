import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/values/app_colors.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/label_value.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/entity/system_overview_report.dart';

import '/app/core/base/base_view.dart';
import '../controllers/system_overview_report_controller.dart';

//ignore: must_be_immutable
class SystemOverviewReportView
    extends BaseView<SystemOverviewReportController> {
  SystemOverviewReportView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.overview,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              _buildCurrentStock(
                controller.systemOverViewReport.value?.currentStock,
              ),
              8.height,
              _buildIncome(
                controller.systemOverViewReport.value?.income,
              ),
              8.height,
              _buildPurchase(
                controller.systemOverViewReport.value?.purchase,
              ),
              8.height,
              _buildSales(
                controller.systemOverViewReport.value?.sales,
              ),
              8.height,
              _buildTransaction(
                controller.systemOverViewReport.value?.transaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStock(CurrentStockOverview? currentStockOverview) {
    return Column(
      crossAxisAlignment: startCAA,
      children: [
        Text(
          appLocalization.currentStock,
          style: commonLabelTextStyle(),
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              LabelValue(
                label: appLocalization.salesPrice,
                value: currentStockOverview?.salesPrice ?? '',
              ),
              LabelValue(
                label: appLocalization.purchasePrice,
                value: currentStockOverview?.purchasePrice ?? '',
              ),
              LabelValue(
                label: appLocalization.profit,
                value: currentStockOverview?.profit ?? '',
              ),
              LabelValue(
                label: appLocalization.quantity,
                value: currentStockOverview?.quantity ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncome(IncomeOverview? incomeOverview) {
    return Column(
      crossAxisAlignment: startCAA,
      children: [
        Text(
          appLocalization.income,
          style: commonLabelTextStyle(),
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              LabelValue(
                label: appLocalization.sales,
                value: incomeOverview?.sales ?? '',
              ),
              LabelValue(
                label: appLocalization.purchase,
                value: incomeOverview?.purchase ?? '',
              ),
              LabelValue(
                label: appLocalization.profit,
                value: incomeOverview?.profit ?? '',
              ),
              LabelValue(
                label: appLocalization.expense,
                value: incomeOverview?.expense ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchase(PurchaseOverview? purchaseOverview) {
    return Column(
      crossAxisAlignment: startCAA,
      children: [
        Text(
          appLocalization.purchase,
          style: commonLabelTextStyle(),
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              LabelValue(
                label: appLocalization.purchase,
                value: purchaseOverview?.purchase ?? '',
              ),
              LabelValue(
                label: appLocalization.amount,
                value: purchaseOverview?.amount ?? '',
              ),
              LabelValue(
                label: appLocalization.payable,
                value: purchaseOverview?.payable ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSales(SalesOverview? salesOverview) {
    return Column(
      crossAxisAlignment: startCAA,
      children: [
        Text(
          appLocalization.sales,
          style: commonLabelTextStyle(),
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              LabelValue(
                label: appLocalization.sales,
                value: salesOverview?.sales ?? '',
              ),
              LabelValue(
                label: appLocalization.amount,
                value: salesOverview?.amount ?? '',
              ),
              LabelValue(
                label: appLocalization.receivable,
                value: salesOverview?.receivable ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransaction(TransactionOverview? transactionOverview) {
    return Column(
      crossAxisAlignment: startCAA,
      children: [
        Text(
          appLocalization.transaction,
          style: commonLabelTextStyle(),
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              LabelValue(
                label: appLocalization.cash,
                value: transactionOverview?.cash ?? '',
              ),
              LabelValue(
                label: appLocalization.stockPrice,
                value: transactionOverview?.stockPrice ?? '',
              ),
              LabelValue(
                label: appLocalization.receivable,
                value: transactionOverview?.receivable ?? '',
              ),
              LabelValue(
                label: appLocalization.payable,
                value: transactionOverview?.payable ?? '',
              ),
              LabelValue(
                label: appLocalization.capital,
                value: transactionOverview?.capital ?? '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dividerWidget() {
    return Column(
      children: [
        8.height,
        Container(
          height: 1,
          color: colors.secondaryColor100,
        ),
        8.height,
      ],
    );
  }

  TextStyle commonLabelTextStyle() {
    return AppTextStyle.h2TextStyle600.copyWith(
      color: colors.primaryColor700,
    );
  }
}

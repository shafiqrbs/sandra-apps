import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
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

  final currency = SetUp().symbol;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.overview,
      ),
      actions: [
        IconButton(
          icon: Icon(
            TablerIcons.share,
            color: colors.whiteColor,
          ),
          onPressed: () {
            controller.generateSystemOverviewPdf();
          },
        ),
        8.width,
      ],
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
                value:
                    '${currency ?? ''} ${currentStockOverview?.salesPrice ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.purchasePrice,
                value:
                    '${currency ?? ''} ${currentStockOverview?.purchasePrice ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.quantity,
                value: currentStockOverview?.quantity ?? '',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.profit,
                value:
                    '${currency ?? ''} ${currentStockOverview?.profit ?? ''}',
                valueTextAlign: TextAlign.end,
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
                value: '${currency ?? ''} ${incomeOverview?.sales ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.purchase,
                value: '${currency ?? ''} ${incomeOverview?.purchase ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.expense,
                value: '${currency ?? ''} ${incomeOverview?.expense ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.profit,
                value: '${currency ?? ''} ${incomeOverview?.profit ?? ''}',
                valueTextAlign: TextAlign.end,
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
                value: '${currency ?? ''} ${purchaseOverview?.purchase ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.payable,
                value: '${currency ?? ''} ${purchaseOverview?.payable ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.payment,
                value: '${currency ?? ''} ${purchaseOverview?.amount ?? ''}',
                valueTextAlign: TextAlign.end,
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
                value: '${currency ?? ''} ${salesOverview?.sales ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.receivable,
                value: '${currency ?? ''} ${salesOverview?.receivable ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.receive,
                value: '${currency ?? ''} ${salesOverview?.amount ?? ''}',
                valueTextAlign: TextAlign.end,
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
                value: '${currency ?? ''} ${transactionOverview?.cash ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.stockPrice,
                value:
                    '${currency ?? ''} ${transactionOverview?.stockPrice ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.receivable,
                value:
                    '${currency ?? ''} ${transactionOverview?.receivable ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.payable,
                value:
                    '${currency ?? ''} ${transactionOverview?.payable ?? ''}',
                valueTextAlign: TextAlign.end,
              ),
              LabelValue(
                label: appLocalization.capital,
                value:
                    '${currency ?? ''} ${transactionOverview?.capital ?? ''}',
                valueTextAlign: TextAlign.end,
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

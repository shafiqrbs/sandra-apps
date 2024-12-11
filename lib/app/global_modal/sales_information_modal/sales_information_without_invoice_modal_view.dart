import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/entity/customer_ledger.dart';
import 'package:sandra/app/global_modal/sales_information_modal/sales_information_without_invoice_modal_controller.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_icon_text.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/label_value.dart';
import '/app/entity/sales.dart';
import 'sales_information_modal_controller.dart';

class SalesInformationWithoutInvoiceModalView
    extends BaseView<SalesInformationWithoutInvoiceModalController> {
  final String salesMode;
  final CustomerLedger customerLedger;
  final Function()? onDeleted;
  final bool? isShowFooter;
  final bool? isFromAccount;
  SalesInformationWithoutInvoiceModalView({
    required this.salesMode,
    required this.customerLedger,
    this.onDeleted,
    this.isShowFooter,
    this.isFromAccount,
    super.key,
  });

  LabelValue get labelValue => LabelValue(
        label: 'label',
        value: 'value',
        labelFontSize: mediumTFSize,
        valueFontSize: mediumTFSize,
        valueFlex: 2,
        labelFlex: 1,
        valueTextAlign: TextAlign.start,
        padding: EdgeInsets.zero,
        labelFontWeight: 600,
        valueFontWeight: 400,
      );

  Widget labelValueComponent({
    required bool isEven,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isEven ? colors.whiteColor : colors.secondaryColor50,
      ),
      child: labelValue.copyWith(
        label: label,
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(
      SalesInformationWithoutInvoiceModalController(
        salesMode: salesMode,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        color: colors.secondaryColor50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryColor100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerBorderRadius),
                    topRight: Radius.circular(containerBorderRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${appLocalization.invoice} : ${customerLedger.invoice ?? ''}',
                      style: AppTextStyle.h3TextStyle600,
                    ),
                    Text(
                      '${appLocalization.date} : ${customerLedger.created ?? ''}',
                      style: AppTextStyle.h3TextStyle600,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  labelValueComponent(
                    isEven: true,
                    label: appLocalization.customer,
                    value: customerLedger.customerName ?? '',
                  ),
                  labelValueComponent(
                    isEven: false,
                    label: appLocalization.mobile,
                    value: customerLedger.mobile ?? '',
                  ),
                  labelValueComponent(
                    isEven: true,
                    label: appLocalization.receive,
                    value:
                        '${SetUp().symbol ?? ''} ${customerLedger.amount?.toString() ?? '0'}',
                  ),
                ],
              ),
            ],
          ),
          16.height,
          if (isShowFooter ?? true)
            Row(
              children: [
                Visibility(
                  visible: controller.sales.value?.approvedBy == null &&
                      controller.isManager,
                  child: Expanded(
                    child: InkWell(
                      onTap: () => controller.deleteSales(
                        onDeleted: onDeleted,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryRedColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.trash,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.delete,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () => controller.salesPrint(
                        context,
                        customerLedger,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryBlueColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.printer,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.print,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (controller.salesMode == 'online' ||
                          controller.salesMode == 'local') &&
                      controller.sales.value?.approvedBy == null &&
                      controller.isManager,
                  child: Expanded(
                    child: InkWell(
                      onTap: controller.goToEditSales,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryGreenColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.pencil,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.edit,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: controller.copySales,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.solidOliveColor.withOpacity(.2),
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              TablerIcons.copy,
                              size: 18,
                              color: colors.solidBlackColor,
                            ),
                            2.height,
                            Text(
                              appLocalization.copy,
                              style: AppTextStyle.h4TextStyle400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' &&
                      controller.sales.value?.approvedBy != null &&
                      controller.isManager,
                  child: Expanded(
                    child: InkWell(
                      onTap: controller.returnSales,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.solidPurpleColor.withOpacity(.2),
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.receipt_refund,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.returnn,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.createSalesDetailsPdf(
                          ledger: customerLedger,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryGreyColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.share,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.share,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                4.width,
              ],
            ),
          if (isFromAccount ?? false)
            Row(
              children: [
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () => controller.salesPrint(
                        context,
                        customerLedger,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryBlueColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.printer,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.print,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.createSalesDetailsPdf(
                          ledger: customerLedger,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryGreyColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.share,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.share,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          1.percentHeight,
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}

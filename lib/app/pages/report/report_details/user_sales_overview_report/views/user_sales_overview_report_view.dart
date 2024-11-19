import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/label_value.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/pages/report/report_details/user_sales_overview_report/controllers/user_sales_overview_report_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class UserSalesOverviewReportView
    extends BaseView<UserSalesOverviewReportController> {
  UserSalesOverviewReportView({super.key});

  final currency = SetUp().symbol;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.userSalesOverview,
      ),
      actions: [
        IconButton(
          icon: Icon(
            TablerIcons.share,
            color: colors.whiteColor,
          ),
          onPressed: () {
            controller.generateUserSalesOverviewPdf();
          },
        ),
        8.width,
      ],
    );
  }

  LabelValue get labelValue => LabelValue(
        label: 'label',
        value: 'value',
        labelFontSize: mediumTFSize,
        valueFontSize: mediumTFSize,
        valueFlex: 2,
        labelFlex: 1,
        valueTextAlign: TextAlign.end,
        padding: EdgeInsets.zero,
        labelFontWeight: 600,
      );

  Widget divider() {
    return Divider(
      color: colors.greyColor.withOpacity(.4),
      thickness: 1,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(
      () => Container(
        child: Column(
          children: [
            8.height,
            Expanded(
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller
                        .userSalesOverViewReport.value?.userSales?.length ??
                    0,
                itemBuilder: (context, index) {
                  final userSales = controller
                      .userSalesOverViewReport.value?.userSales?[index];
                  if (userSales == null) return Container();
                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryColor50,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: defaultBoxShadow(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userSales.salesBy}',
                          style: AppTextStyle.h1TextStyle600.copyWith(
                            color: colors.primaryColor500,
                          ),
                        ),
                        divider(),
                        4.height,
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16,),
                          child: Column(
                            children: [
                              labelValue.copyWith(
                                label: appLocalization.sales,
                                value:
                                    '$currency ${userSales.total?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                              labelValue.copyWith(
                                label: appLocalization.salesReceive,
                                value:
                                    '$currency ${userSales.amount?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                              divider(),
                              labelValue.copyWith(
                                label: appLocalization.due,
                                value: '$currency ${controller.getDueAmount(
                                      totalAmount: userSales.total ?? 0,
                                      receiveAmount: userSales.amount ?? 0,
                                    ).toStringAsFixed(2)}',
                              ),
                              labelValue.copyWith(
                                label: appLocalization.dueReceive,
                                value:
                                    '$currency ${userSales.dueReceive?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                              divider(),
                              labelValue.copyWith(
                                label: appLocalization.outstanding,
                                value:
                                    '$currency ${controller.getOutstandingAmount(
                                          totalAmount: userSales.total ?? 0,
                                          receiveAmount:
                                              userSales.amount ?? 0,
                                          dueReceiveAmount:
                                              userSales.dueReceive ?? 0,
                                        ).toStringAsFixed(2)}',
                                valueFontWeight: 800,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

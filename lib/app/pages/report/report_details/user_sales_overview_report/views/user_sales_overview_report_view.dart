import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
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
            //controller.generateSystemOverviewPdf();
          },
        ),
        8.width,
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(()=>
      Container(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount:
                  controller.userSalesOverViewReport.value?.userSales?.length ??
                      0,
              itemBuilder: (context, index) {
                final userSales =
                    controller.userSalesOverViewReport.value?.userSales?[index];
                if (userSales == null) return Container();
                return Container(
                  child: Column(
                    children: [
                      Text(userSales.salesBy ?? ''),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

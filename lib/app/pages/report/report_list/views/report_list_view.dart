import 'package:flutter/material.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/pages/report/report_list/controllers/report_list_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class ReportListView extends BaseView<ReportListController> {
  ReportListView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.report,
      ),
    );
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  
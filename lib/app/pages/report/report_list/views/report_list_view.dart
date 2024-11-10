import 'package:flutter/material.dart';
import 'package:sandra/app/pages/report/report_list/controllers/report_list_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class ReportListView extends BaseView<ReportListController> {
  ReportListView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  
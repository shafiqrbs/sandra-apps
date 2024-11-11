import 'package:flutter/material.dart';

import '/app/core/base/base_view.dart';
import '../controllers/system_overview_report_controller.dart';

//ignore: must_be_immutable
class SystemOverviewReportView extends BaseView<SystemOverviewReportController> {
  SystemOverviewReportView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  
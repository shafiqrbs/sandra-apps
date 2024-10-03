import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/help_page/controllers/help_page_controller.dart';

//ignore: must_be_immutable
class HelpPageView extends BaseView<HelpPageController> {
  HelpPageView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  
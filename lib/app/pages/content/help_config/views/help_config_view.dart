import 'package:flutter/material.dart';

import '/app/core/base/base_view.dart';
import '/app/pages/content/help_config/controllers/help_config_controller.dart';

//ignore: must_be_immutable
class HelpConfigView extends BaseView<HelpConfigController> {
  HelpConfigView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}

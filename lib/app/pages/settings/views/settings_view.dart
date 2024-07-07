import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/settings/controllers/settings_controller.dart';

//ignore: must_be_immutable
class SettingsView extends BaseView<SettingsController> {
  SettingsView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  
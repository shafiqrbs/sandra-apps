import 'package:flutter/material.dart';

import '/app/core/base/base_view.dart';
import '/app/pages/content/account_config/controllers/account_config_controller.dart';

//ignore: must_be_immutable
class AccountConfigView extends BaseView<AccountConfigController> {
  AccountConfigView({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  
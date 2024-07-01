import 'package:flutter/material.dart';

import '/app/core/base/base_view.dart';
import '/app/core/widget/custom_app_bar.dart';
import '/app/pages/home/controllers/home_controller.dart';

class HomeView extends BaseView<HomeController> {
  HomeView() {}

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'GetX Templates on GitHub',
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}

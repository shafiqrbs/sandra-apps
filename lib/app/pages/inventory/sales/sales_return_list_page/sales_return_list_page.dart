import 'package:flutter/material.dart';
import 'package:sandra/app/core/base/base_view.dart';
import 'package:sandra/app/core/widget/app_bar_button_group.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';

import 'sales_return_list_controller.dart';

class SalesReturnListPage extends BaseView<SalesReturnListController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.refundList,
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            QuickNavigationButton(),
          ],
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/help_page/controllers/help_page_controller.dart';

//ignore: must_be_immutable
class HelpPageView extends BaseView<HelpPageController> {
  HelpPageView({super.key});

  final String currency = SetUp().symbol ?? '';

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: PageBackButton(
        pageTitle: appLocalization.help,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: HtmlWidget(
          SetUp().appsManual ?? '',
        ),
      ),
    );
  }
}

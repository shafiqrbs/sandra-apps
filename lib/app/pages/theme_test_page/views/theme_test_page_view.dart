import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/theme_test_page/controllers/theme_test_page_controller.dart';

//ignore: must_be_immutable
class ThemeTestPageView extends BaseView<ThemeTestPageController> {
  ThemeTestPageView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: InkWell(
              onTap: controller.changeTheme,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: colors.primaryColor900,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

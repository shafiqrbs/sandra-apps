import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/widget/add_button.dart';
import '/app/core/widget/app_bar_button_group.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/inventory/particular/controllers/particular_controller.dart';

//ignore: must_be_immutable
class ParticularView extends BaseView<ParticularController> {
  ParticularView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: Text(
        'particular'.tr,
        style: TextStyle(
          color: colors.backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            AddButton(
              onTap: controller.showAddParticularModal,
            ),
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

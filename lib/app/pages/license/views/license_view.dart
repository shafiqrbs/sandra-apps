import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/utils/responsive.dart';
import 'package:getx_template/app/core/widget/row_button.dart';
import 'package:getx_template/app/core/widget/setup_bottom_nav_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/license/controllers/license_controller.dart';

//ignore: must_be_immutable
class LicenseView extends BaseView<LicenseController> {
  LicenseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildForm(),
      ],
    );
  }

  @override
  Widget bottomNavigationBar() {
    return _buildBottomNavigationBar();
  }

  Widget _buildHeader() {
    return Container();
  }

  Widget _buildForm() {
    return Container();
  }

  Widget _buildBottomNavigationBar() {
    return SetupBottomNavBar(
      buttonList: [
        RowButton(
          buttonName: 'close'.tr,
          leftIcon: TablerIcons.x,
          isOutline: true,
          onTap: Get.back,
        ),
        1.percentWidth,
        RowButton(
          buttonName: 'login'.tr,
          leftIcon: TablerIcons.login,
          isOutline: false,
          onTap: controller.submitLicense,
        ),
      ],
    );
  }
}

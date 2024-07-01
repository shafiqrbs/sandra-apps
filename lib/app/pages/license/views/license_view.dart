import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import '/app/core/widget/setup_bottom_nav_bar.dart';
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
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.moduleBodyColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 16.ph),
            child: Column(
              children: [
                12.percentHeight,
                _buildTitleAndDescription(),
              ],
            ),
          ),
        ),
        Container(
          height: 20.ph,
          width: Get.width,
          decoration: BoxDecoration(
            color: colors.primaryBaseColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
        ),
        _buildAvatar(),
      ],
    );
  }

  Widget _buildTitleAndDescription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                alignment: Alignment.topCenter,
                child: CommonText(
                  text: 'register'.tr,
                  fontSize: dimensions.headerTFSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.height,
              CommonText(
                text: 'please_fill_all_the_information_correctly'.tr,
                fontSize: dimensions.subHeaderTFSize,
                textColor: colors.secondaryTextColor,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.only(top: 10.ph),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              color: colors.iconBackgroundColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    TablerIcons.user_square,
                    color: colors.iconColor,
                    size: 60,
                  ),
                  Text(
                    'license'.tr,
                    style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.v, horizontal: 10.h),
            child: Column(
              children: [
                FBString(
                  textController: controller.licenseNumberController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: 'enter_license_number'.tr,
                  label: 'license_number'.tr,
                  errorMsg: 'license_number_required'.tr,
                  preFixIcon: TablerIcons.license,
                ),
                FBString(
                  textController: controller.activeKeyController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: 'enter_active_number'.tr,
                  label: 'active_number'.tr,
                  errorMsg: 'active_number_required'.tr,
                  preFixIcon: TablerIcons.key,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

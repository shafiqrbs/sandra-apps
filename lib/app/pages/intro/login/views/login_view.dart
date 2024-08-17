import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/widget/common_cache_image_widget.dart';

import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/language_change_dropdown.dart';
import '/app/core/widget/row_button.dart';
import '/app/core/widget/setup_bottom_nav_bar.dart';
import '/app/pages/intro/login/controllers/login_controller.dart';

//ignore: must_be_immutable
class LoginView extends BaseView<LoginController> {
  LoginView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildForm(),
        ],
      ),
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
        Positioned(
          top: AppBar().preferredSize.height - 24,
          right: 16,
          child: LanguageChangeDropDown(),
        ),
        _buildAvatar(),
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
                  commonCacheImageWidget(
                    SetUp().logo,
                    130,
                    width: 130,
                    fit: BoxFit.cover,
                    isOval: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                  text: appLocalization.login,
                  fontSize: headerTFSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              1.percentHeight,
              Container(
                color: Colors.transparent,
                alignment: Alignment.topCenter,
                child: CommonText(
                  text: appLocalization.welcome,
                  fontSize: headerTFSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              1.percentHeight,
              CommonText(
                text: appLocalization.toStore,
                fontSize: subHeaderTFSize,
                textColor: colors.secondaryTextColor,
                textAlign: TextAlign.left,
              ),
              1.percentHeight,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * .35,
                      alignment: Alignment.center,
                      color: controller.isSignUp.value
                          ? colors.selectedColor
                          : colors.primaryBaseColor,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 16,
                        top: 12,
                        bottom: 12,
                      ),
                      child: Text(
                        appLocalization.login,
                        style: boldTextStyle(
                          color: !controller.isSignUp.value
                              ? white
                              : colors.primaryTextColor,
                        ),
                      ),
                    )
                        .cornerRadiusWithClipRRectOnly(
                      topLeft: 4,
                      bottomLeft: 4,
                    )
                        .onTap(
                      () {
                        controller.isSignUp.value = false;
                      },
                    ),
                    Container(
                      width: Get.width * .35,
                      alignment: Alignment.center,
                      color: controller.isSignUp.value
                          ? colors.primaryBaseColor
                          : colors.selectedColor,
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 20,
                        top: 12,
                        bottom: 12,
                      ),
                      child: Text(
                        appLocalization.otpLogin,
                        style: boldTextStyle(
                          color: controller.isSignUp.value
                              ? white
                              : colors.primaryTextColor,
                        ),
                      ),
                    )
                        .cornerRadiusWithClipRRectOnly(
                      topRight: 4,
                      bottomRight: 4,
                    )
                        .onTap(
                      () {
                        controller.isSignUp.value = true;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.v, horizontal: 10.h),
            child: Obx(
              () => Column(
                children: [
                  FBString(
                    textController: controller.userNameController,
                    preFixIcon: TablerIcons.user,
                    label: appLocalization.userName,
                    textInputAction: done,
                    hint: appLocalization.enterUsernameHere,
                    errorMsg: appLocalization.userNameRequired,
                    isRequired: true,
                    isShowToolTip: false,
                    toolTipIcon: TablerIcons.info_square_rounded,
                    toolTipIconColor: colors.dangerLiteColor,
                    toolTipContent: '8 characters required',
                  ).visible(!controller.isSignUp.value),
                  //16.height,

                  FBString(
                    textController: controller.passwordController,
                    isRequired: true,
                    label: appLocalization.password,
                    //example: 'example'.tr,
                    hint: appLocalization.enterPassword,
                    errorMsg: appLocalization.passwordRequired,
                    preFixIcon: TablerIcons.key,
                  ).visible(!controller.isSignUp.value),

                  FBString(
                    textController: controller.otpController,
                    isRequired: true,
                    label: appLocalization.mobileNo,
                    hint: appLocalization.enterMobileNo,
                    //example: "017**********".tr,
                    errorMsg: appLocalization.mobileNoRequired,
                    preFixIcon: TablerIcons.device_mobile,
                  ).visible(controller.isSignUp.value),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: CommonText(
                            text: appLocalization.forgotPassword,
                            fontSize: regularTFSize,
                            textColor: colors.dangerLiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.percentHeight,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonText(
                        text: appLocalization.donNotHaveAnAccount,
                        fontSize: subHeaderTFSize,
                        textColor: colors.secondaryTextColor,
                      ),
                      4.width,
                      CommonText(
                        text: appLocalization.createAccount,
                        fontSize: subHeaderTFSize,
                        textColor: colors.primaryTextColor,
                        fontWeight: FontWeight.w600,
                        textDecoration: TextDecoration.underline,
                      ).onTap(
                        () {
                          // Get.to(RegisterScreen());
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
          buttonName: appLocalization.close,
          leftIcon: TablerIcons.x,
          isOutline: true,
          onTap: Get.back,
        ),
        1.percentWidth,
        RowButton(
          buttonName: appLocalization.login,
          leftIcon: TablerIcons.login,
          isOutline: false,
          onTap: controller.submitLogin,
        ),
      ],
    );
  }
}

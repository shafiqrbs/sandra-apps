import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/utils/style_function.dart';
import 'package:sandra/app/core/widget/show_snack_bar.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '/app/core/core_model/setup.dart';
import '/app/core/widget/common_cache_image_widget.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/language_change_dropdown.dart';
import '/app/core/widget/setup_bottom_nav_bar.dart';
import '/app/pages/intro/login/controllers/login_controller.dart';

//ignore: must_be_immutable
class LoginView extends BaseView<LoginController> {
  LoginView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          child: LanguageChangeDropDown(),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: SuperTooltip(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: controller.clearLicense,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: colors.solidBlackColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            arrowTipDistance: 10,
            arrowLength: 8,
            arrowBaseWidth: 8,
            //right: -16,
            hideTooltipOnTap: true,
            //elevation: 0,
            hasShadow: false,
            backgroundColor: Colors.white,
            borderRadius: 4,
            barrierColor: Colors.transparent,
            child: const Icon(
              TablerIcons.dots_vertical,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await confirmationModal(
          msg: appLocalization.areYouSureYouWantToExit,
        );
        return shouldExit; // Return true to exit, false to cancel
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildForm(),
          ],
        ),
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
            color: colors.secondaryColor50,
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
            color: colors.primaryColor500,
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
              color: colors.primaryColor50,
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
                  text: appLocalization.welcome,
                  fontSize: headerTFSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              1.percentHeight,
              CommonText(
                text: SetUp().name ?? '',
                fontSize: subHeaderTFSize,
                textColor: colors.primaryBlackColor,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w600,
              ),
              4.percentHeight,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * .35,
                      alignment: Alignment.center,
                      color: controller.isSignUp.value
                          ? colors.primaryColor50
                          : colors.primaryColor500,
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
                              : colors.solidBlackColor,
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
                          ? colors.primaryColor500
                          : colors.primaryColor50,
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
                              : colors.solidBlackColor,
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
                    toolTipIconColor: colors.primaryRedColor,
                    toolTipContent: '8 characters required',
                  ).visible(!controller.isSignUp.value),
                  //16.height,

                  Obx(
                    () => FBString(
                      textController: controller.passwordController,
                      isRequired: true,
                      isShowPassword: controller.isPasswordHidden.value,
                      label: appLocalization.password,
                      //example: 'example'.tr,
                      hint: appLocalization.enterPassword,
                      errorMsg: appLocalization.passwordRequired,
                      preFixIcon: TablerIcons.key,
                      decoration: formBuilderInputDecorationWithPassword(
                          hint: appLocalization.enterPassword,
                          textEditingController: controller.passwordController,
                          isShowClearIcon: false,
                          isShowPasswordIcon: controller.isPasswordHidden.value,
                          passwordOnTap: controller.togglePasswordVisibility,
                          suffixIconSize: 14),
                    ).visible(!controller.isSignUp.value),
                  ),

                  FBString(
                    textController: controller.otpController,
                    isRequired: true,
                    label: appLocalization.mobileNo,
                    hint: appLocalization.enterMobileNo,
                    //example: "017**********".tr,
                    errorMsg: appLocalization.mobileNoRequired,
                    preFixIcon: TablerIcons.device_mobile,
                  ).visible(controller.isSignUp.value),

                  //_buildForgotPassword(),
                  20.height,
                  // _buildCreateAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            showSnackBar(
              type: SnackBarType.error,
              message:
                  appLocalization.doNotAllowDiscountValueMoreThenSubtotalValue,
            );
            toast(appLocalization.underDevelopment);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: CommonText(
              text: appLocalization.forgotPassword,
              fontSize: regularTFSize,
              textColor: colors.primaryRedColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccount() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonText(
          text: appLocalization.donNotHaveAnAccount,
          fontSize: subHeaderTFSize,
          textColor: colors.primaryBlackColor,
        ),
        4.width,
        CommonText(
          text: appLocalization.createAccount,
          fontSize: subHeaderTFSize,
          textColor: colors.solidBlackColor,
          fontWeight: FontWeight.w600,
          textDecoration: TextDecoration.underline,
        ).onTap(
          () {
            Get.toNamed(Routes.createStore);
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return SetupBottomNavBar(
      buttonList: [
        RowButton(
          buttonName: appLocalization.reset,
          leftIcon: TablerIcons.x,
          isOutline: true,
          onTap: controller.resetForm,
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

import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/singleton_classes/fb_typography.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/fb_string.dart';
import 'package:sandra/app/entity/business_type.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';
import 'package:sandra/app/pages/intro/onboarding/controllers/onboarding_controller.dart';

//ignore: must_be_immutable
class CreateStoreView extends BaseView<CreateStoreController> {
  CreateStoreView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: colors.primaryColor50,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              20.height,
              _buildWelcomeHeading(),
              24.height,
              _buildCreateStoreForm(),
              24.height,
              _buildLoginInfoForm(),
              24.height,
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeading() {
    return Text(
      appLocalization.welcomeToPOSKeeper,
      textAlign: TextAlign.center,
      style: AppTextStyle.h1TextStyle600.copyWith(
        color: colors.blackColor500,
      ),
    );
  }

  Widget _buildCreateStoreForm() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              appLocalization.createYourOnlineStore,
              style: AppTextStyle.h2TextStyle500.copyWith(
                color: colors.primaryColor500,
              ),
            ),
          ),
          Divider(
            color: colors.primaryColor500,
          ),
          4.height,
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalization.businessModel,
                        style: FBTypography().tfLabelTS,
                        maxLines: 1,
                      ),
                      4.height,
                      DropdownFlutter<BusinessType>(
                        hintText: appLocalization.businessModel,
                        items: controller.businessTypeList.value,
                        onChanged: controller.onBusinessTypeChange,
                        overlayHeight: 500,
                        listItemBuilder: (context, value, ___, option) {
                          return Text(
                            value.name ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                        headerBuilder: (context, value, option) {
                          return Text(
                            value.name ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                        hintBuilder: (context, value, option) {
                          return Text(
                            value,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF989898),
                            ),
                          );
                        },
                        decoration: controller.dropDownDecoration,
                        itemsListPadding: EdgeInsets.zero,
                        closedHeaderPadding: const EdgeInsets.all(8),
                      ),
                      controller.isShowErrorMsg.value
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                appLocalization.requiredField,
                                style: FBTypography().tfErrorMsgTS,
                              ),
                            )
                          : Container(),
                      controller.isShowErrorMsg.value ? 0.height : 12.height,
                    ],
                  ),
                ),
                FBString(
                  textController: controller.shopNameController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.shopCompanyName,
                  label: appLocalization.shopCompanyName,
                  errorMsg: appLocalization.requiredField,
                  keyboardType: textInputType,
                ),
                FBString(
                  textController: controller.mobileController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterMobileNumberHere,
                  label: appLocalization.mobile,
                  errorMsg: appLocalization.mobileNoIsRequired,
                  keyboardType: numberInputType,
                ),
                FBString(
                  textController: controller.emailController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterEmail,
                  label: appLocalization.email,
                  errorMsg: appLocalization.requiredField,
                  keyboardType: emailAddressInputType,
                ),
                FBString(
                  textController: controller.addressController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterAddressHere,
                  label: appLocalization.address,
                  errorMsg: appLocalization.requiredField,
                  keyboardType: textInputType,
                ),
                _buildCheckBox(
                  isActive: controller.isAllowReadyStock,
                  text: appLocalization.areYouInterestedToReadyStock,
                ),
                16.height,
                _buildCheckBox(
                  isActive: controller.isAllowTerms,
                  text: appLocalization.iAcceptTermsAndConditions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginInfoForm() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              appLocalization.loginInformation,
              style: AppTextStyle.h2TextStyle500.copyWith(
                color: colors.primaryColor500,
              ),
            ),
          ),
          Divider(
            color: colors.primaryColor500,
          ),
          4.height,
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FBString(
                  textController: controller.nameController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterNameHere,
                  label: appLocalization.name,
                  errorMsg: appLocalization.nameRequired,
                  keyboardType: textInputType,
                ),
                FBString(
                  textController: controller.userNameController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterUsernameHere,
                  label: appLocalization.userName,
                  errorMsg: appLocalization.userNameRequired,
                  keyboardType: textInputType,
                ),
                FBString(
                  textController: controller.passwordController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterPassword,
                  label: appLocalization.password,
                  errorMsg: appLocalization.passwordRequired,
                  keyboardType: textInputType,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBox({
    required RxBool isActive,
    required String text,
  }) {
    return Obx(
      () => Row(
        children: [
          InkWell(
            onTap: () {
              isActive.value = !isActive.value;
              print('isActive: $isActive');
              controller.update();
            },
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color:
                    isActive.value ? colors.primaryColor500 : colors.whiteColor,
                border: Border.all(
                  color: isActive.value
                      ? colors.primaryColor500
                      : colors.secondaryColor100,
                ),
              ),
              child: isActive.value
                  ? Icon(
                      Icons.check,
                      color: colors.whiteColor,
                      size: 20,
                    )
                  : null,
            ),
          ),
          12.width,
          Text(
            text,
            style: AppTextStyle.h3TextStyle400.copyWith(
              color: colors.blackColor500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildButtonWidget(
              text: appLocalization.buildStore,
              onPressed: () {
                controller.buildStore();
              },
            ),
          ),
          24.width,
          Expanded(
            child: _buildButtonWidget(
              text: appLocalization.skip,
              color: colors.secondaryColor500,
              onPressed: () {
                Get.find<OnboardingController>().pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWidget({
    required String text,
    required Function() onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: color ?? colors.primaryColor500,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: AppTextStyle.h3TextStyle600.copyWith(
            color: colors.whiteColor,
          ),
        ),
      ),
    );
  }
}

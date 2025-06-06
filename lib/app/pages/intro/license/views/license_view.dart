import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/widget/common_cache_image_widget.dart';

import '/app/core/widget/fb_string.dart';
import '/app/core/widget/setup_bottom_nav_bar.dart';
import '/app/pages/intro/license/controllers/license_controller.dart';

//ignore: must_be_immutable
class LicenseView extends BaseView<LicenseController> {
  LicenseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primaryColor500,
      ),
      body: body(context),
      bottomNavigationBar: bottomNavigationBar(),
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
                  text: appLocalization.licenseSetUp,
                  fontSize: headerTFSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.height,
              CommonText(
                text: appLocalization.pleaseFillAllTheInformationCorrectly,
                fontSize: subHeaderTFSize,
                textColor: colors.primaryBlackColor,
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
                  hint: appLocalization.enterLicenseNumber,
                  label: appLocalization.licenseNumber,
                  errorMsg: appLocalization.licenseNumberRequired,
                  preFixIcon: TablerIcons.license,
                  keyboardType: numberInputType,
                ),
                FBString(
                  textController: controller.activeKeyController,
                  isRequired: true,
                  onChange: (value) {},
                  hint: appLocalization.enterActiveNumber,
                  label: appLocalization.activeNumber,
                  errorMsg: appLocalization.activeNumberRequired,
                  preFixIcon: TablerIcons.key,
                  keyboardType: numberInputType,
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
          buttonName: appLocalization.setUp,
          isOutline: false,
          onTap: controller.submitLicense,
        ),
      ],
    );
  }
}

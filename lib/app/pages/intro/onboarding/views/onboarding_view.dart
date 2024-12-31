import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/asset_image_view.dart';
import 'package:sandra/app/global_widget/video_player_widget.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';
import 'package:sandra/app/pages/intro/create_store/views/create_store_view.dart';
import 'package:sandra/app/pages/intro/license/controllers/license_controller.dart';
import 'package:sandra/app/pages/intro/license/views/license_view.dart';
import 'package:sandra/app/pages/intro/onboarding/controllers/onboarding_controller.dart';

//ignore: must_be_immutable
class OnboardingView extends BaseView<OnboardingController> {
  OnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Color pageBackgroundColor() {
    return colors.primaryColor50;
  }

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: colors.primaryColor50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              height: Get.height * 0.9,
              color: colors.primaryColor50,
              child: PageView(
                controller: controller.pageController,
                children: [
                  _buildWelcomeView(context),
                  _buildCreateStoreView(),
                  _buildLicenseView(),
                ],
              ),
            ),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor50,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            20.height,
            _buildWelcomeHeading(),
            24.height,
            _buildVideoSection(),
            20.height,
            _buildNewStoreSection(),
            20.height,
            _buildSetupSection(),
            20.height,
            _buildViewDemoButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateStoreView() {
    Get.put(CreateStoreController());
    return CreateStoreView();
  }

  Widget _buildLicenseView() {
    Get.put(LicenseController());
    return LicenseView();
  }

  Widget _buildWelcomeHeading() {
    return Text(
      appLocalization.welcomeToPOSKeeper,
      style: AppTextStyle.h1TextStyle600.copyWith(
        color: colors.blackColor500,
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            appLocalization.createYourOnlineStore,
            style: AppTextStyle.h2TextStyle500.copyWith(
              color: colors.primaryColor500,
            ),
          ),
          20.height,
          const AssetImageView(
            fileName: 'onboarding_logo.png',
            height: 90,
            width: 90,
          ),
          20.height,
          Container(
            height: 170,
            child: VideoPlayerWidget(
                videoUrl: 'https://youtu.be/CPclGyYCGtY?si=ij6TYhxRl-6noWwB'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewStoreSection() {
    return Column(
      children: [
        Text(
          appLocalization.newStoreDetails,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: AppTextStyle.h4TextStyle400.copyWith(
            color: colors.secondaryColor500,
          ),
        ),
        12.height,
        _buildButtonWidget(
          text: appLocalization.newStore,
          onPressed: () {
            controller.pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSetupSection() {
    return Column(
      children: [
        Text(
          'Already have a Store! Want to create my own App? ',
          style: AppTextStyle.h4TextStyle400,
        ),
        RichTextWidget(
          list: [
            TextSpan(
              text: 'Click on ',
              style: AppTextStyle.h4TextStyle400.copyWith(
                color: colors.blackColor400,
              ),
            ),
            TextSpan(
              text: '"${appLocalization.setUp} "',
              style: AppTextStyle.h4TextStyle600.copyWith(
                color: colors.secondaryColor500,
              ),
            ),
          ],
        ),
        12.height,
        _buildButtonWidget(
          text: appLocalization.setUp,
          onPressed: () {
            controller.pageController.jumpToBottom();
          },
          color: colors.secondaryColor500,
        ),
      ],
    );
  }

  Widget _buildViewDemoButton(BuildContext context) {
    return InkWell(
      onTap: () => controller.viewDemoModal(context),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: colors.primaryColor500,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              TablerIcons.eye,
              size: 20,
              color: colors.primaryColor500,
            ),
            4.width,
            Text(
              appLocalization.viewDemo,
              style: AppTextStyle.h3TextStyle600.copyWith(
                color: colors.primaryColor500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWidget({
    required String text,
    required Function() onPressed,
    Color? color,
    Color? borderColor,
    Color? textColor,
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
          border: borderColor != null
              ? Border.all(
                  color: borderColor,
                )
              : null,
        ),
        child: Text(
          text,
          style: AppTextStyle.h3TextStyle600.copyWith(
            color: textColor ?? colors.whiteColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: SmoothPageIndicator(
        controller: controller.pageController,
        count: 3,
        effect: WormEffect(
          dotWidth: 12,
          dotHeight: 4,
          activeDotColor: colors.primaryColor500,
          dotColor: colors.primaryColor100,
        ),
      ),
    );
  }
}

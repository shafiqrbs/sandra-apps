import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/asset_image_view.dart';
import 'package:sandra/app/global_widget/video_player_widget.dart';
import 'package:sandra/app/pages/intro/onboarding/controllers/onboarding_controller.dart';

//ignore: must_be_immutable
class OnboardingView extends BaseView<OnboardingController> {
  OnboardingView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            bottom: 40,
          ),
          height: Get.height * 0.85,
          child: PageView(
            controller: controller.pageController,
            children: [
              _buildWelcomeView(),
              Container(
                color: Colors.green,
                child: Center(
                  child: Text('Page 2'),
                ),
              ),
              Container(
                color: Colors.blue,
                child: Center(
                  child: Text('Page 3'),
                ),
              ),
            ],
          ),
        ),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildWelcomeView() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor50,
      ),
      child: Column(
        children: [
          20.height,
          _buildWelcomeHeading(),
          24.height,
          _buildVideoSection(),
          32.height,
          _buildNewStoreSection(),
          32.height,
          _buildSetupSection(),
        ],
      ),
    );
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
            controller.pageController.jumpTo(3);
          },
          color: colors.secondaryColor500,
        ),
      ],
    );
  }

  Widget _buildButtonWidget({
    required String text,
    required Function() onPressed,
    Color? color,
  }) {
    return Container(
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

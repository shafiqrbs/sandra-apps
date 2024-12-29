import 'package:get/get.dart';
import 'package:sandra/app/pages/intro/onboarding/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
  }
}
  
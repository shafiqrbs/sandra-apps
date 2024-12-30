import 'package:sandra/app/core/importer.dart';

class OnboardingController extends BaseController {
  final pageController = PageController();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

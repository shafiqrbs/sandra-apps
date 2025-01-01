import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/global_modal/view_demo_modal/view_demo_modal_view.dart';

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

  Future<void> viewDemoModal(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: appLocalization.viewDemo,
          subTitle: appLocalization.viewDemoSubtitle,
          subTitleAlign: TextAlign.center,
          child: ViewDemoModalView(),
        );
      },
    );
  }
}

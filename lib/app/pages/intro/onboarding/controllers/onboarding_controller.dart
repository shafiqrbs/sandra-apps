import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/onboard_entity.dart';
import 'package:sandra/app/global_modal/view_demo_modal/view_demo_modal_view.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';

class OnboardingController extends BaseController {
  final pageController = PageController();
  final onBoardSetupData = Rx<OnboardEntity?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = await Get.arguments;
    onBoardSetupData.value = args['onboardData'];

    final createStoreController = Get.put(CreateStoreController());
    createStoreController.businessTypeList.value = onBoardSetupData.value?.demo;
    createStoreController.terms.value =
        onBoardSetupData.value?.termsCondition ?? '';
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
          subTitle: '',
          subTitleAlign: TextAlign.center,
          child: ViewDemoModalView(),
        );
      },
    );
  }
}

import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/business_type.dart';
import 'package:sandra/app/entity/onboard_entity.dart';

class ViewDemoController extends BaseController {
  final onBoardSetupData = Rx<OnboardEntity?>(null);
  final businessTypeList = Rx<List<BusinessType>?>(null);
  final tappedIndex = (-1).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await dataFetcher(future: () async {
      await getOnboardSetup();
    },);
    businessTypeList.value = onBoardSetupData.value?.demo;
  }

  void setTappedIndex(int index) {
    if (tappedIndex.value == index) {
      tappedIndex.value = -1; // Collapse if the same item is clicked
    } else {
      tappedIndex.value = index; // Expand the clicked item
    }
    tappedIndex.refresh();
  }

  Future<void> getOnboardSetup() async {
    final response = await services.getOnboardSetup();
    if (response != null) {
      onBoardSetupData.value = response;
    }
  }
}

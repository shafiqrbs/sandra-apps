import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';

class TermsAndConditionModalView extends BaseView<CreateStoreController> {
  TermsAndConditionModalView({super.key});

  final falsePadding = 16.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<CreateStoreController>(
      init: CreateStoreController(),
      builder: (controller) {
        return Center(
          child: Container(
            height: Get.height * 0.7,
            padding: EdgeInsets.all(falsePadding.value),
            decoration: BoxDecoration(
              color: colors.whiteColor,
            ),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    'Terms and Conditions',
                    style: AppTextStyle.h1TextStyle500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}

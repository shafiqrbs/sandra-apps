import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/global_modal/view_demo_modal/view_demo_modal_controller.dart';

class ViewDemoModalView extends BaseView<ViewDemoModalController> {
  ViewDemoModalView({super.key});

  final falsePadding = 16.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<ViewDemoModalController>(
      init: ViewDemoModalController(),
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
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.businessTypeList.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = controller.businessTypeList.value![index];
                      return Obx(
                        () => _buildDemoCardView(
                          name: item.name ?? '',
                          title: item.title ?? '',
                          subTitle: item.content ?? '',
                          onTap: () {
                            controller.setTappedIndex(index);
                          },
                          navigationToDemo: () {
                            controller.navigateToDemo(item);
                          },
                          isTapped: controller.tappedIndex.value == index,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoCardView({
    required String name,
    required String title,
    required String subTitle,
    required Function() onTap,
    required Function() navigationToDemo,
    required bool isTapped,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: Get.width,
              margin: const EdgeInsets.only(
                right: 16,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: colors.primaryColor50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.h1TextStyle500.copyWith(
                      color: colors.secondaryColor500,
                    ),
                  ),
                  Text(
                    title,
                    style: AppTextStyle.h4TextStyle400.copyWith(
                      color: colors.secondaryColor400,
                    ),
                  ),
                  4.height,
                  isTapped
                      ? HtmlWidget(
                          subTitle,
                          textStyle: AppTextStyle.h4TextStyle400.copyWith(
                            color: colors.secondaryColor400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: navigationToDemo,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: colors.primaryColor600,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    TablerIcons.arrow_right,
                    color: colors.whiteColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

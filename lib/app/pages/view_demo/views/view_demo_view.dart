import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/entity/business_type.dart';

import '/app/pages/view_demo/controllers/view_demo_controller.dart';

//ignore: must_be_immutable
class ViewDemoView extends BaseView<ViewDemoController> {
  ViewDemoView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: Text(
        appLocalization.viewDemo,
        style: AppTextStyle.h1TextStyle500.copyWith(
          color: colors.primaryColor600,
        ),
      ),
      centerTitle: true,
      backgroundColor: colors.whiteColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          TablerIcons.arrow_left,
          color: colors.primaryColor600,
        ),
        onPressed: Get.back,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Obx(
              () => ListView.builder(
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
                        controller.setTappedIndex(index);
                      },
                      isTapped: controller.tappedIndex.value == index,
                      type: item,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCardView({
    required String name,
    required String title,
    required String subTitle,
    required Function() onTap,
    required Function() navigationToDemo,
    required bool isTapped,
    required BusinessType type,
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
                  4.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'URL : ${type.url ?? 'https://demo.poskeeper.com'}',
                        style: AppTextStyle.h3TextStyle500.copyWith(
                          color: colors.primaryColor600,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type.url ?? 'https://demo.poskeeper.com',
                            ),
                          );
                        },
                        icon: Icon(
                          TablerIcons.copy,
                          color: colors.secondaryColor500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${appLocalization.licenseNumber} : ${type.licenseNo}',
                        style: AppTextStyle.h4TextStyle400.copyWith(
                          color: colors.primaryColor600,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type.licenseNo ?? '',
                            ),
                          );
                        },
                        icon: Icon(
                          TablerIcons.copy,
                          color: colors.secondaryColor500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${appLocalization.activeNumber} : ${type.activeKey}',
                        style: AppTextStyle.h4TextStyle400.copyWith(
                          color: colors.primaryColor600,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type.activeKey ?? '',
                            ),
                          );
                        },
                        icon: Icon(
                          TablerIcons.copy,
                          color: colors.secondaryColor500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${appLocalization.userName} : ${type.userName}',
                        style: AppTextStyle.h4TextStyle400.copyWith(
                          color: colors.primaryColor600,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type.userName ?? '',
                            ),
                          );
                        },
                        icon: Icon(
                          TablerIcons.copy,
                          color: colors.secondaryColor500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${appLocalization.password} : ${type.password}',
                        style: AppTextStyle.h4TextStyle400.copyWith(
                          color: colors.primaryColor600,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: type.password ?? '',
                            ),
                          );
                        },
                        icon: Icon(
                          TablerIcons.copy,
                          color: colors.secondaryColor500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
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
                    isTapped ? TablerIcons.arrow_right : TablerIcons.arrow_down,
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
}

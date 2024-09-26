import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class RestaurantHomeView extends BaseView<RestaurantHomeController> {
  RestaurantHomeView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors.primaryColor500,
      leading: IconButton(
        icon: Icon(
          TablerIcons.arrow_left,
          size: 24,
          color: colors.whiteColor,
        ),
        onPressed: Get.back,
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: colors.primaryColor50,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Icon(
                TablerIcons.shopping_cart,
                color: colors.primaryColor500,
                size: 18,
              ),
              6.width,
              Text(
                '27',
                style: AppTextStyle.h3TextStyle600.copyWith(
                  color: colors.primaryColor500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}

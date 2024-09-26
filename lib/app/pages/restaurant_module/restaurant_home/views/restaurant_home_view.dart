import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/values/app_values.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/common_cache_image_widget.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import 'package:sandra/app/pages/restaurant_module/restaurant_home/controllers/restaurant_home_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class RestaurantHomeView extends BaseView<RestaurantHomeController> {
  final currency = SetUp().symbol ?? '';
  RestaurantHomeView({super.key});

  @override
  Color pageBackgroundColor() {
    return colors.secondaryColor50;
  }

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
                TablerIcons.shopping_cart_copy,
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
              8.width,
              Text(
                '|',
                style: AppTextStyle.h3TextStyle600.copyWith(
                  color: colors.primaryColor200,
                ),
              ),
              8.width,
              Text(
                '$currency 2700',
                style: AppTextStyle.h3TextStyle700.copyWith(
                  color: colors.secondaryColor500,
                ),
              ),
            ],
          ),
        ),
        16.width,
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          10.height,
          _buildTableList(),
          _buildSearchBar(),
          10.height,
          _buildMenuList(),
        ],
      ),
    );
  }

  Widget _buildTableList() {
    return HorizontalList(
      itemCount: 20,
      spacing: 10,
      itemBuilder: (context, index) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 12,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(
                  AppValues.radius_8,
                ),
                border: Border.all(
                  color: colors.secondaryColor100,
                ),
              ),
              child: Column(
                children: [
                  10.height,
                  Text(
                    '${appLocalization.table} - 1',
                    style: AppTextStyle.h2TextStyle700.copyWith(
                      color: colors.blackColor500,
                    ),
                  ),
                  14.height,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryColor50,
                      borderRadius: BorderRadius.circular(
                        AppValues.radius_4,
                      ),
                    ),
                    child: Text(
                      '07:02:26',
                      style: AppTextStyle.h3TextStyle600.copyWith(
                        color: colors.blackColor400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 26,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryColor500,
                  borderRadius: BorderRadius.circular(
                    AppValues.radius_100,
                  ),
                ),
                child: Text(
                  appLocalization.hold,
                  style: AppTextStyle.h3TextStyle700.copyWith(
                    color: colors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: appLocalization.search,
                hintStyle: AppTextStyle.h3TextStyle400.copyWith(
                  color: colors.blackColor200,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: colors.whiteColor,
                suffixIcon: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.primaryColor50,
                    borderRadius: BorderRadius.circular(
                      AppValues.radius_8,
                    ),
                  ),
                  child: Icon(
                    TablerIcons.search,
                    size: 18,
                    color: colors.primaryColor500,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppValues.radius_8,
                  ),
                  borderSide: BorderSide(
                    color: colors.secondaryColor100,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppValues.radius_8,
                  ),
                  borderSide: BorderSide(
                    color: colors.secondaryColor100,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppValues.radius_8,
                  ),
                  borderSide: BorderSide(
                    color: colors.secondaryColor100,
                  ),
                ),
              ),
            ),
          ),
          8.width,
          GestureDetector(
            onTap: controller.changeMenuView,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(
                  AppValues.radius_8,
                ),
              ),
              child: Icon(
                controller.menuView.value == MenuView.list
                    ? TablerIcons.layout_grid
                    : TablerIcons.list_details,
                size: 24,
                color: colors.secondaryColor500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return controller.menuView.value == MenuView.list
        ? _buildMenuListView()
        : _buildMenuGridView();
  }

  Widget _buildMenuListView() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: 10,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(
                  AppValues.radius_4,
                ),
                border: Border.all(
                  color: colors.secondaryColor50,
                ),
              ),
              child: Row(
                children: [
                  commonCachedNetworkImage(
                    'https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg',
                    height: 74,
                    width: 120,
                    radius: 2,
                  ),
                  10.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 42,
                          child: Text(
                            'Margherita Pizza with sau Margherita Pizza ',
                            maxLines: 2,
                            style: AppTextStyle.h3TextStyle700.copyWith(
                              color: colors.blackColor500,
                            ),
                          ),
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$currency 2700',
                              style: AppTextStyle.h2TextStyle700.copyWith(
                                color: colors.blackColor600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colors.primaryColor50,
                                borderRadius: BorderRadius.circular(
                                  AppValues.radius_4,
                                ),
                              ),
                              child: Icon(
                                TablerIcons.basket,
                                size: 20,
                                color: colors.primaryColor500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuGridView() {
    return Expanded(
      child: Container(
          child: GridView.builder(
        itemCount: 10,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(
                AppValues.radius_8,
              ),
              border: Border.all(
                color: colors.secondaryColor100,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chicken Burger',
                  style: AppTextStyle.h3TextStyle600.copyWith(
                    color: colors.blackColor500,
                  ),
                ),
                8.height,
                Text(
                  'Chicken Burger with extra cheese',
                  style: AppTextStyle.h4TextStyle400.copyWith(
                    color: colors.blackColor400,
                  ),
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$currency 2700',
                      style: AppTextStyle.h3TextStyle700.copyWith(
                        color: colors.primaryColor500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryColor50,
                        borderRadius: BorderRadius.circular(
                          AppValues.radius_4,
                        ),
                      ),
                      child: Text(
                        appLocalization.add,
                        style: AppTextStyle.h3TextStyle600.copyWith(
                          color: colors.primaryColor500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}

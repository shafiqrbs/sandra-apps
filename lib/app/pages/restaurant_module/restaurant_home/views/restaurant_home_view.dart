import 'package:sandra/app/core/importer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/utils/responsive.dart';
import 'package:sandra/app/core/values/app_values.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/app_bar_search_view.dart';
import 'package:sandra/app/core/widget/common_cache_image_widget.dart';
import 'package:sandra/app/core/widget/page_back_button.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
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
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.pos,
      ),
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          onTap: () => controller.goToOrderCart(
            context: context,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colors.primaryColor50,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Obx(
              () => Row(
                children: [
                  Icon(
                    TablerIcons.shopping_cart_copy,
                    color: colors.primaryColor500,
                    size: 18,
                  ),
                  6.width,
                  Text(
                    controller.addSelectedFoodItem
                            .value[controller.selectedTableId.value]?.length
                            .toString() ??
                        '0',
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
                    '$currency ${controller.calculateTotalAmount(
                      controller.addSelectedFoodItem
                              .value[controller.selectedTableId.value] ??
                          [],
                    )}',
                    style: AppTextStyle.h3TextStyle700.copyWith(
                      color: colors.secondaryColor500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        8.width,
        QuickNavigationButton(),
        16.width,
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.centerLeft,
        children: [
          Column(
            children: [
              0.height,
              Visibility(
                visible: controller.isTableEnabled.value,
                child: _buildTableList(),
              ),
              _buildSearchBar(),
              _buildMenuList(),
            ],
          ),
          Positioned(
            left: 0,
            child: Transform.translate(
              offset: const Offset(
                -24,
                0,
              ), // Adjust this value to move the widget to the left
              child: Transform.rotate(
                angle: -3.14159 / 2, // Rotate 90 degrees (π/2 radians)
                child: GestureDetector(
                  onTap: () => controller.openMenuBottomSheet(context: context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          AppValues.radius_8,
                        ),
                        bottomRight: Radius.circular(
                          AppValues.radius_8,
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          colors.primaryColor500,
                          colors.secondaryColor500,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensure the size is adjusted to content
                      children: [
                        Icon(
                          TablerIcons.tools_kitchen_2,
                          size: 20,
                          color: colors.whiteColor,
                        ),
                        6.width,
                        Text(
                          appLocalization.menu,
                          style: AppTextStyle.h2TextStyle700.copyWith(
                            color: colors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableList() {
    return HorizontalList(
      itemCount: controller.tableList.value?.length ?? 0,
      spacing: 10,
      itemBuilder: (context, index) {
        final table = controller.tableList.value?[index];
        if (controller.tableList.value == null) return Container();
        return Obx(
          () => GestureDetector(
            onTap: () {
              controller.selectTable(index, table!);
            },
            onLongPress: () {
              if (controller.selectedTableIndex.value == index) {
                controller.goToOrderCart(
                  context: context,
                );
              }
            },
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: controller.selectedTableIndex.value == index
                        ? colors.secondaryColor500
                        : colors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      AppValues.radius_8,
                    ),
                    border: Border.all(
                      color: colors.secondaryColor100,
                    ),
                  ),
                  child: Column(
                    children: [
                      4.height,
                      Text(
                        table?.tableName ?? '',
                        style: AppTextStyle.h2TextStyle700.copyWith(
                          color: controller.selectedTableIndex.value == index
                              ? colors.whiteColor
                              : colors.textColor500,
                        ),
                      ),
                      4.height,
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
                          controller.tableStatusTimeList.value[index],
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
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryColor500,
                      borderRadius: BorderRadius.circular(
                        AppValues.radius_100,
                      ),
                    ),
                    child: Text(
                      controller.tableStatusList.value[index].name
                          .capitalizeFirstLetter(),
                      style: AppTextStyle.h3TextStyle700.copyWith(
                        color: colors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      height: 40.sp,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              onChanged: (value) {
                controller.onSearch(value);
              },
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
              height: double.infinity,
              padding: const EdgeInsets.all(8),
              width: 36.sp,
              margin: const EdgeInsets.only(
                left: 4,
                top: 4,
                bottom: 4,
              ),
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
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(
            AppValues.radius_8,
          ),
        ),
        child: ListView.builder(
          itemCount: controller.filteredStockList.value?.length ?? 0,
          itemBuilder: (context, index) {
            final stock = controller.filteredStockList.value?[index];
            if (controller.stockList.value == null) return Container();
            return Obx(
              () => GestureDetector(
                onTap: () => controller.selectFoodItem(stock!),
                child: Container(
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
                      color: controller.selectedFoodList.contains(index)
                          ? colors.primaryColor500
                          : colors.secondaryColor100,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: startCAA,
                    children: [
                      commonCachedNetworkImage(
                        stock?.imagePath ??
                            'https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg',
                        //height: 74,
                        width: 120,
                        radius: 2,
                        fit: BoxFit.fitWidth,
                      ),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock?.categoryName ?? '',
                              maxLines: 1,
                              style: AppTextStyle.h4TextStyle400.copyWith(
                                color: colors.textColor300,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 42,
                              child: Text(
                                stock?.name ?? '',
                                maxLines: 2,
                                style: AppTextStyle.h3TextStyle700.copyWith(
                                  color: colors.textColor500,
                                ),
                              ),
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    '$currency ${stock?.salesPrice}',
                                    style: AppTextStyle.h2TextStyle700.copyWith(
                                      color: colors.textColor600,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                ),
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
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(
            AppValues.radius_8,
          ),
        ),
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: controller.filteredStockList.value?.length ?? 0,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemBuilder: (context, index) {
            final stock = controller.filteredStockList.value?[index];
            if (controller.stockList.value == null) return Container();
            return Obx(
              () => GestureDetector(
                onTap: () => controller.selectFoodItem(stock!),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      AppValues.radius_4,
                    ),
                    border: Border.all(
                      color: controller.selectedFoodList.contains(index)
                          ? colors.primaryColor500
                          : colors.secondaryColor100,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonCachedNetworkImage(
                        stock?.imagePath ??
                            'https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg',
                        width: double.infinity,
                        radius: 2,
                      ),
                      8.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            stock?.categoryName ?? '',
                            maxLines: 1,
                            style: AppTextStyle.h4TextStyle400.copyWith(
                              color: colors.textColor300,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(
                            height: 42,
                            child: Text(
                              stock?.name ?? '',
                              maxLines: 2,
                              style: AppTextStyle.h3TextStyle700.copyWith(
                                color: colors.textColor500,
                              ),
                            ),
                          ),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  '$currency ${stock?.salesPrice}',
                                  style: AppTextStyle.h2TextStyle700.copyWith(
                                    color: colors.textColor600,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(
            AppValues.radius_8,
          ),
        ),
        child: GridView.builder(
          itemCount: controller.filteredStockList.value?.length ?? 0,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .75,
          ),
          itemBuilder: (context, index) {
            final stock = controller.filteredStockList.value?[index];
            if (controller.stockList.value == null) return Container();
            return Obx(
              () => GestureDetector(
                onTap: () => controller.selectFoodItem(stock!),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      AppValues.radius_4,
                    ),
                    border: Border.all(
                      color: controller.selectedFoodList.contains(index)
                          ? colors.primaryColor500
                          : colors.secondaryColor100,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonCachedNetworkImage(
                        stock?.imagePath ??
                            'https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg',
                        width: double.infinity,
                        radius: 2,
                      ),
                      8.height,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock?.categoryName ?? '',
                              maxLines: 1,
                              style: AppTextStyle.h4TextStyle400.copyWith(
                                color: colors.textColor300,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 42,
                              child: Text(
                                stock?.name ?? '',
                                maxLines: 2,
                                style: AppTextStyle.h3TextStyle700.copyWith(
                                  color: colors.textColor500,
                                ),
                              ),
                            ),
                            8.height,
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$currency ${stock?.salesPrice}',
                                      style:
                                          AppTextStyle.h2TextStyle700.copyWith(
                                        color: colors.textColor600,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget? bottomNavigationBar() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor50,
      ),
      child: Obx(
        () {
          if (!controller.isTableEnabled.value) {
            return const SizedBox(
              height: 0,
              width: 0,
            );
          }
          return Row(
            children: [
              _buildBottomNavbarCard(
                icon: TablerIcons.tools_kitchen_2,
                isSelected: controller.bottomStatus.value == BottomStatus.order,
                text: appLocalization.order,
                onTap: () {
                  controller.changeBottomStatus(BottomStatus.order);
                },
              ),
              4.width,
              _buildBottomNavbarCard(
                icon: TablerIcons.grill,
                isSelected:
                    controller.bottomStatus.value == BottomStatus.kitchen,
                text: appLocalization.kitchen,
                onTap: () {
                  controller.changeBottomStatus(BottomStatus.kitchen);
                },
              ),
              4.width,
              _buildBottomNavbarCard(
                icon: TablerIcons.hand_grab,
                isSelected: controller.bottomStatus.value == BottomStatus.hold,
                text: appLocalization.hold,
                onTap: () {
                  controller.changeBottomStatus(BottomStatus.hold);
                },
              ),
              4.width,
              _buildBottomNavbarCard(
                icon: TablerIcons.soup,
                isSelected:
                    controller.bottomStatus.value == BottomStatus.booked,
                text: appLocalization.booked,
                onTap: () {
                  controller.changeBottomStatus(BottomStatus.booked);
                },
              ),
              4.width,
              _buildBottomNavbarCard(
                icon: TablerIcons.picnic_table,
                isSelected: controller.bottomStatus.value == BottomStatus.free,
                text: appLocalization.free,
                onTap: () {
                  controller.changeBottomStatus(BottomStatus.free);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavbarCard({
    required IconData icon,
    required bool isSelected,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppValues.radius_4,
            ),
            color: isSelected ? colors.secondaryColor500 : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: minMAS,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? colors.whiteColor : colors.blackColor500,
              ),
              2.height,
              Text(
                text,
                style: AppTextStyle.h4TextStyle400.copyWith(
                  color: isSelected ? colors.whiteColor : colors.blackColor500,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

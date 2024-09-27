import 'dart:async';
import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/bindings/initial_binding.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/values/app_values.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/pages/restaurant_module/order_cart/controllers/order_cart_controller.dart';
import '/app/core/base/base_view.dart';

//ignore: must_be_immutable
class OrderCartView extends BaseView<OrderCartController> {
  OrderCartView({super.key});

  final currency = SetUp().symbol;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      backgroundColor: Colors.black.withOpacity(.5),
      shadowColor: Colors.white.withOpacity(.8),
      elevation: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius: BorderRadius.circular(
              AppValues.radius_8,
            ),
          ),
          child: Obx(
            () => Column(
              children: [
                _buildOrderCategory(),
                4.height,
                _buildSelectAdditionalTable(),
                14.height,
                _buildOrderItemList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCategory() {
    return Row(
      children: [
        Expanded(
          child: DropdownFlutter<String>(
            hintText: 'Select status',
            items: controller.orderCategoryList,
            initialItem: controller.orderCategoryList[0],
            onChanged: (value) {
              log('changing value to: $value');
            },
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: CustomDropdownDecoration(
              closedBorder: Border.all(
                color: colors.secondaryColor100,
              ),
              closedBorderRadius: BorderRadius.circular(
                AppValues.radius_4,
              ),
              closedFillColor: colors.whiteColor,
              closedSuffixIcon: Icon(
                TablerIcons.chevron_down,
                color: colors.blackColor500,
                size: 20,
              ),
              headerStyle: AppTextStyle.h3TextStyle400.copyWith(
                color: colors.textColor300,
              ),
              listItemStyle: AppTextStyle.h3TextStyle400.copyWith(
                color: colors.textColor500,
              ),
            ),
          ),
        ),
        8.width,
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: colors.primaryColor500,
            borderRadius: BorderRadius.circular(AppValues.radius_4),
          ),
          child: Row(
            children: [
              Icon(
                TablerIcons.chef_hat,
                size: 24,
                color: colors.whiteColor,
              ),
              4.width,
              Text(
                appLocalization.kitchen,
                style: AppTextStyle.h3TextStyle500.copyWith(
                  color: colors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectAdditionalTable() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor500,
        borderRadius: BorderRadius.circular(
          AppValues.radius_4,
        ),
      ),
      child: Row(
        mainAxisAlignment: spaceBetweenMAA,
        children: [
          Text(
            appLocalization.selectAdditionalTable,
            style: AppTextStyle.h3TextStyle500.copyWith(
              color: colors.whiteColor,
            ),
          ),
          GestureDetector(
            onTap: controller.changeAdditionTableSelection,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppValues.radius_4,
                ),
                border: Border.all(
                  color: colors.whiteColor,
                  width: 1.5,
                ),
              ),
              child: controller.isAdditionalTableSelected.value
                  ? Icon(
                      TablerIcons.check,
                      color: colors.whiteColor,
                      size: 12,
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildOrderItemCard(
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildOrderItemCard({
    required int index,
  }) {
    Timer? timer;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 8,
            left: 10,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: colors.secondaryColor50.withOpacity(.5),
            borderRadius: BorderRadius.circular(
              AppValues.radius_4,
            ),
            border: Border.all(
              color: colors.blackColor50,
            ),
          ),
          child: Row(
            crossAxisAlignment: startCAA,
            children: [
              Expanded(
                child: Text(
                  index.isEven
                      ? 'this is test cheese burger with french fry'
                      : ' Cheese Pizza',
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: AppTextStyle.h3TextStyle400.copyWith(
                    color: colors.textColor600,
                  ),
                ),
              ),
              20.width,
              Obx(
                () {
                  return Column(
                    crossAxisAlignment: endCAA,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.decreaseQuantity(index),
                            onLongPressStart: (details) {
                              timer = Timer.periodic(
                                const Duration(milliseconds: 100),
                                (t) {
                                  controller.decreaseQuantity(index);
                                },
                              );
                            },
                            onLongPressEnd: (details) {
                              if (timer != null) {
                                timer!.cancel();
                              }
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.secondaryColor50,
                              ),
                              child: Icon(
                                TablerIcons.minus,
                                size: 18,
                                color: colors.blackColor500,
                              ),
                            ),
                          ),
                          4.width,
                          SizedBox(
                            width: 30,
                            child: Text(
                              controller.itemQuantities[index].toString(),
                              textAlign: TextAlign.center,
                              style: AppTextStyle.h3TextStyle500.copyWith(
                                color: colors.textColor500,
                              ),
                            ),
                          ),
                          4.width,
                          GestureDetector(
                            onTap: () => controller.increaseQuantity(index),
                            onLongPressStart: (details) {
                              timer = Timer.periodic(
                                const Duration(milliseconds: 100),
                                (t) {
                                  controller.increaseQuantity(index);
                                },
                              );
                            },
                            onLongPressEnd: (details) {
                              if (timer != null) {
                                timer!.cancel();
                              }
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.secondaryColor500,
                              ),
                              child: Icon(
                                TablerIcons.plus,
                                size: 18,
                                color: colors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      6.height,
                      Text(
                        '${currency ?? ''} ${2000 * controller.itemQuantities[index]}',
                        textAlign: TextAlign.right,
                        style: AppTextStyle.h3TextStyle400.copyWith(
                          color: colors.textColor600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              TablerIcons.trash,
              color: colors.redColor,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/bindings/initial_binding.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/utils/responsive.dart';
import 'package:sandra/app/core/utils/style_function.dart';
import 'package:sandra/app/core/values/app_values.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/core/widget/common_cache_image_widget.dart';
import 'package:sandra/app/core/widget/common_text.dart';
import 'package:sandra/app/core/widget/label_value.dart';
import 'package:sandra/app/entity/stock.dart';
import 'package:sandra/app/entity/transaction_methods.dart';
import 'package:sandra/app/global_widget/customer_card_view.dart';
import 'package:sandra/app/global_widget/transaction_method_item_view.dart';
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
            () => SingleChildScrollView(
              child: Container(
                height: 90.ph,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      _buildStatusBar(),
                      _buildOrderCategory(context),
                      4.height,
                      _buildSelectAdditionalTable(),
                      14.height,
                      _buildOrderItemList(),
                      8.height,
                      _buildSubTotal(),
                      12.height,
                      _buildOrderCartInfo(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: spaceBetweenMAA,
      children: [
        Text(
          controller.isTableEnabled.value
              ? '${appLocalization.table}: ${controller.tableName.value}'
              : '',
          style: AppTextStyle.h2TextStyle500.copyWith(
            color: colors.blackColor500,
          ),
        ),
        GestureDetector(
          onTap: Get.back,
          child: Container(
            width: 40,
            alignment: Alignment.centerRight,
            child: Icon(
              TablerIcons.x,
              size: 24,
              color: colors.blackColor500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCategory(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownFlutter<String>(
            hintText: 'Select status',
            items: controller.orderCategoryList,
            initialItem: controller.orderCategoryList[0],
            onChanged: (value) {
              if (value != null) {
                controller.selectedOrderCategory.value = value;
              }
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
        GestureDetector(
          onTap: ()=> controller.kitchenPrint(context),
          child: Container(
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
        ),
      ],
    );
  }

  Widget _buildSelectAdditionalTable() {
    return Column(
      children: [
        GestureDetector(
          onTap: controller.changeAdditionTableSelection,
          child: Container(
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
                Container(
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
                  child: Icon(
                    controller.isAdditionalTableSelected.value
                        ? TablerIcons.chevron_up
                        : TablerIcons.chevron_down,
                    color: colors.whiteColor,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: controller.isAdditionalTableSelected.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: colors.primaryColor50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(
                  AppValues.radius_4,
                ),
                bottomRight: Radius.circular(
                  AppValues.radius_4,
                ),
              ),
            ),
            child: Wrap(
              spacing: 4,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              alignment: startWA,
              runSpacing: 8,
              children: [
                _buildAdditionalTableCardView(index: 0),
                _buildAdditionalTableCardView(index: 1),
                _buildAdditionalTableCardView(index: 2),
                _buildAdditionalTableCardView(index: 3),
                _buildAdditionalTableCardView(index: 4),
                _buildAdditionalTableCardView(index: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalTableCardView({
    required int index,
  }) {
    final isSelected = false.obs;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            isSelected.value = !isSelected.value;
          },
          child: Row(
            mainAxisSize: minMAS,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppValues.radius_4,
                  ),
                  border: Border.all(
                    color: colors.blackColor300,
                  ),
                ),
                child: isSelected.value
                    ? Icon(
                        TablerIcons.check,
                        color: colors.blackColor500,
                        size: 12,
                      )
                    : Container(),
              ),
              8.width,
              Text(
                'T ${index + 1}',
                style: AppTextStyle.h3TextStyle500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.cartItems.value?.length ?? 0,
        itemBuilder: (context, index) {
          final item = controller.cartItems.value?[index];
          if (item == null) return Container();
          return _buildOrderItemCard(
            index: index,
            item: item,
          );
        },
      ),
    );
  }

  Widget _buildOrderItemCard({
    required int index,
    required Stock item,
  }) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 8,
            right: 10,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
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
          child: Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: Row(
              crossAxisAlignment: startCAA,
              children: [
                commonCachedNetworkImage(
                  item.imagePath ??
                      'https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg',
                  width: 50,
                  height: 50,
                  radius: AppValues.radius_4,
                ),
                8.width,
                Expanded(
                  child: Text(
                    item.name ?? '',
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
                    return Container(
                      width: 80,
                      height: 54,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Column(
                            crossAxisAlignment: endCAA,
                            children: [
                              Row(
                                mainAxisAlignment: endMAA,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.showQuantityUpdate(index),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 60,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(
                                            AppValues.radius_4,
                                          ),
                                          topRight: const Radius.circular(
                                            AppValues.radius_4,
                                          ),
                                          bottomLeft: Radius.circular(
                                            controller.showQuantityUpdateList
                                                    .contains(index)
                                                ? 0
                                                : AppValues.radius_4,
                                          ),
                                          bottomRight: Radius.circular(
                                            controller.showQuantityUpdateList
                                                    .contains(index)
                                                ? 0
                                                : AppValues.radius_4,
                                          ),
                                        ),
                                        color: colors.whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: centerMAA,
                                        children: [
                                          Text(
                                            controller.itemQuantities[index]
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.h3TextStyle500
                                                .copyWith(
                                              color: colors.textColor500,
                                            ),
                                          ),
                                          4.width,
                                          Icon(
                                            controller.showQuantityUpdateList
                                                    .contains(index)
                                                ? TablerIcons.chevron_up
                                                : TablerIcons.chevron_down,
                                            size: 16,
                                            color: colors.blackColor500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              6.height,
                              Text(
                                '${currency ?? ''} ${item.salesPrice! * controller.itemQuantities[index]}',
                                textAlign: TextAlign.right,
                                style: AppTextStyle.h3TextStyle400.copyWith(
                                  color: colors.textColor600,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: -2,
                            child: controller.showQuantityUpdateList
                                    .contains(index)
                                ? Container(
                                    width: 60,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                          AppValues.radius_6,
                                        ),
                                        bottomRight: Radius.circular(
                                          AppValues.radius_6,
                                        ),
                                      ),
                                      color: colors.whiteColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: centerMAA,
                                      crossAxisAlignment: centerCAA,
                                      children: [
                                        GestureDetector(
                                          onTap: () => controller
                                              .decreaseQuantity(index),
                                          onLongPressStart: (details) {
                                            controller
                                                .startQuantityDecreaseTimer(
                                                    index);
                                          },
                                          onLongPressEnd: (details) {
                                            controller.stopQuantityTimer();
                                          },
                                          child: Icon(
                                            TablerIcons.minus,
                                            size: 16,
                                            color: colors.blackColor500,
                                          ),
                                        ),
                                        8.width,
                                        GestureDetector(
                                          onTap: () => controller
                                              .increaseQuantity(index),
                                          onLongPressStart: (details) {
                                            controller
                                                .startQuantityIncreaseTimer(
                                                    index);
                                          },
                                          onLongPressEnd: (details) {
                                            controller.stopQuantityTimer();
                                          },
                                          child: Icon(
                                            TablerIcons.plus,
                                            size: 16,
                                            color: colors.blackColor500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: InkWell(
            onTap: () => controller.deleteItem(index),
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
        ),
      ],
    );
  }

  Widget _buildSubTotal() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryColor500,
      ),
      child: Row(
        mainAxisAlignment: spaceBetweenMAA,
        children: [
          Text(
            '${appLocalization.subTotal} - ',
            style: AppTextStyle.h1TextStyle600.copyWith(
              color: colors.whiteColor,
            ),
          ),
          Text(
            '${currency ?? ''} ${controller.tableInvoice.value?.subTotal ?? 0.00}',
            style: AppTextStyle.h1TextStyle700.copyWith(
              color: colors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCartInfo(context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colors.primaryColor50,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomerSearch(context),
            Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        8.height,
                        _buildInvoiceSummery(),
                        8.height,
                        _buildTransactionMethod(context),
                        8.height,
                        _buildPaymentReceiveRow(context),
                        10.height,
                        Container(
                          height: 1,
                          color: colors.blackColor100,
                        ),
                        10.height,
                        _buildBottomButton(context),
                        1.percentHeight,
                      ],
                    ),
                    _buildCustomerListView(context),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSearch(
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: textFieldHeight,
                child: TextFormField(
                  controller:
                      controller.customerManager.searchTextController.value,
                  cursorColor: colors.solidBlackColor,
                  decoration: buildInputDecoration(
                    prefixIcon: Icon(
                      TablerIcons.search,
                      size: 16,
                      color: colors.primaryBlackColor,
                    ),
                    suffixIcon: Obx(
                      () {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.isShowClearIcon.value
                                ? InkWell(
                                    onTap: () {
                                      controller.customerManager
                                          .searchTextController.value
                                          .clear();
                                      controller.isShowClearIcon.value = false;
                                      controller.customerManager.selectedItem
                                          .value = null;
                                    },
                                    child: Icon(
                                      TablerIcons.x,
                                      size: 12,
                                      color: colors.solidRedColor,
                                    ),
                                  )
                                : Container(),
                            IconButton(
                              onPressed: controller.addCustomer,
                              icon: Icon(
                                TablerIcons.user_plus,
                                size: 20,
                                color: colors.primaryColor500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    hintText: appLocalization.searchCustomer,
                    hintStyle: TextStyle(
                      color: colors.primaryBlackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: mediumTFSize.sp,
                    ),
                    fillColor: colors.primaryColor25,
                    enabledBorderColor: colors.secondaryColor100,
                    focusedBorderColor: colors.secondaryColor100,
                    errorBorderColor: colors.secondaryColor100,
                  ),
                  textAlign: startTA,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: mediumTFSize.sp,
                  ),
                  onChanged: (value) async {
                    if (value.isEmpty ?? true) {
                      controller.isShowClearIcon.value = false;
                      controller.customerManager.searchedItems.value = [];
                      controller.customerManager.selectedItem.value = null;
                      return;
                    }
                    controller.isShowClearIcon.value = true;
                    await controller.customerManager.searchItemsByName(value);
                  },
                ),
              ),
            ),
          ],
        ),
        4.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: appLocalization.dontYouHaveCustomer,
              fontSize: smallTFSize,
              fontWeight: FontWeight.w400,
              textColor: colors.solidBlackColor,
            ),
            InkWell(
              onTap: controller.addCustomer,
              child: CommonText(
                text: appLocalization.addCustomer,
                fontSize: mediumTFSize,
                fontWeight: FontWeight.w500,
                textColor: colors.primaryColor500,
                textDecoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        Obx(
          () => controller.customerManager.selectedItem.value != null
              ? Column(
                  children: [
                    1.percentHeight,
                    CustomerCardView(
                      data: controller.customerManager.selectedItem.value!,
                      index: 0,
                      onTap: () {},
                      onReceive: () {},
                      showReceiveButton: false,
                    ),
                  ],
                )
              : Container(),
        ),
        8.height,
      ],
    );
  }

  Widget _buildCustomerListView(
    BuildContext context,
  ) {
    return Obx(
      () => controller.customerManager.searchedItems.value?.isNotEmpty ?? false
          ? Container(
              color: Colors.white,
              height: 40.ph,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    controller.customerManager.searchedItems.value?.length ?? 0,
                itemBuilder: (context, index) {
                  return CustomerCardView(
                    data:
                        controller.customerManager.searchedItems.value![index],
                    index: index,
                    onTap: () {
                      controller.updateCustomer(
                        controller.customerManager.searchedItems.value![index],
                      );
                      FocusScope.of(context).unfocus();
                    },
                    onReceive: () {},
                    showReceiveButton: false,
                  );
                },
              ),
            )
          : Container(),
    );
  }

  Widget _buildInvoiceSummery() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(
          AppValues.radius_4,
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: minMAS,
                children: [
                  LabelValue(
                    label: appLocalization.vat,
                    value: '${currency ?? ''} ${controller.salesVat.value}',
                    dividerText: '',
                    labelFontSize: 12,
                    valueFontSize: 12,
                    valueFontWeight: 900,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                  ),
                  LabelValue(
                    label: appLocalization.sc,
                    value: '${currency ?? ''} 0.00',
                    dividerText: '',
                    labelFontSize: 12,
                    valueFontSize: 12,
                    valueFontWeight: 900,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                  ),
                  LabelValue(
                    label: appLocalization.dis,
                    value:
                        '${currency ?? ''} ${controller.salesDiscount.value}',
                    dividerText: '',
                    labelFontSize: 12,
                    valueFontSize: 12,
                    valueFontWeight: 900,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppValues.radius_4,
                  ),
                  color: colors.primaryColor50,
                ),
                child: Column(
                  children: [
                    Text(
                      appLocalization.total,
                      style: AppTextStyle.h3TextStyle500.copyWith(
                        color: colors.textColor500,
                      ),
                    ),
                    Text(
                      '${currency ?? ''} ${controller.netTotal}',
                      style: AppTextStyle.h2TextStyle700.copyWith(
                        color: colors.primaryColor800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionMethod(
    BuildContext context,
  ) {
    return Obx(
      () => Column(
        children: [
          if (controller.transactionMethodsManager.allItems.value != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(
                  AppValues.radius_4,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 4,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  runSpacing: 8,
                  children:
                      controller.transactionMethodsManager.allItems.value!.map(
                    (e) {
                      final selected = controller
                          .transactionMethodsManager.selectedItem.value;
                      return _buildTransactionMethodItemView(
                        method: e,
                        isSelected: selected == e,
                        onTap: () {
                          controller
                              .transactionMethodsManager.selectedItem.value = e;
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionMethodItemView({
    required TransactionMethods method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppValues.radius_4,
                ),
                color: Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? colors.secondaryColor500
                      : colors.secondaryColor50,
                ),
              ),
              child: Container(
                //height: 22,
                //width: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  color: Colors.transparent,
                ),
                child: commonCacheImageWidget(
                  method.imagePath,
                  24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            4.height,
            Text(
              method.methodMode ?? '',
              style: AppTextStyle.h3TextStyle400.copyWith(
                color: isSelected ? colors.textColor500 : colors.textColor300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentReceiveRow(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () {
              return AdvancedSwitch(
                activeChild: const Text('%'),
                inactiveChild: Text(appLocalization.flat),
                activeColor: colors.primaryColor700,
                inactiveColor: colors.secondaryColor100,
                borderRadius: BorderRadius.circular(
                  containerBorderRadius,
                ),
                height: 36,
                width: 90,
                controller: controller.discountTypeController.value,
                onChanged: (value) {
                  controller.changeDiscountType(value);
                },
              );
            },
          ),
        ),
        8.width,
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextFormField(
              controller: controller.paymentDiscountController.value,
              cursorColor: colors.solidBlackColor,
              textAlignVertical: TextAlignVertical.center,
              decoration: buildInputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                hintText: appLocalization.discount,
                hintStyle: TextStyle(
                  color: colors.primaryBlackColor,
                  fontWeight: FontWeight.normal,
                  fontSize: mediumTFSize,
                ),
                fillColor: colors.whiteColor,
                enabledBorderColor: colors.primaryColor200,
                focusedBorderColor: colors.primaryColor500,
                errorBorderColor: colors.primaryColor200,
              ),
              inputFormatters: doubleInputFormatter,
              keyboardType: numberInputType,
              textAlign: centerTA,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: mediumTFSize,
              ),
              onChanged: (value) {
                controller.salesSubTotal.value = double.tryParse(
                  controller.tableInvoice.value?.subTotal.toString() ?? '00',
                )!;
                controller.onDiscountChange(value);
              },
            ),
          ),
        ),
        8.width,
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextFormField(
              controller: controller.amountController.value,
              inputFormatters: doubleInputFormatter,
              textInputAction: doneInputAction,
              onEditingComplete: () =>
                  controller.showConfirmationDialog(context),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: regularTFSize,
              ),
              cursorColor: colors.solidBlackColor,
              decoration: buildInputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                hintText: appLocalization.amount,
                hintStyle: TextStyle(
                  color: colors.primaryBlackColor,
                  fontWeight: FontWeight.normal,
                  fontSize: mediumTFSize,
                ),
                fillColor: colors.whiteColor,
                enabledBorderColor: colors.primaryColor200,
                focusedBorderColor: colors.primaryColor500,
                errorBorderColor: colors.primaryColor200,
              ).copyWith(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.primaryColor400,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.primaryColor400,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => controller.onAmountChange(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
  ) {
    return Row(
      children: [
        _buildButtonView(
          text: appLocalization.postPrint,
          icon: TablerIcons.printer,
          bgColor: colors.secondaryColor500,
          onTap: ()=> controller.printSalesWithToken(context),
        ),
        10.width,
        _buildButtonView(
          text: appLocalization.save,
          icon: TablerIcons.device_floppy,
          bgColor: colors.primaryColor500,
          onTap: () => controller.showConfirmationDialog(context),
        ),
      ],
    );
  }

  Widget _buildButtonView({
    required String text,
    required IconData icon,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppValues.radius_4,
            ),
            color: bgColor,
          ),
          child: Row(
            mainAxisAlignment: centerMAA,
            children: [
              Icon(
                icon,
                size: 20,
                color: colors.whiteColor,
              ),
              8.width,
              Text(
                text,
                style: AppTextStyle.h3TextStyle500.copyWith(
                  color: colors.whiteColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

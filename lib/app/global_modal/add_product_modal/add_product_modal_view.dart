import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
import 'package:nb_utils/nb_utils.dart';

import 'add_product_modal_controller.dart';

class AddProductModalView extends BaseView<AddProductModalViewController> {
  AddProductModalView({super.key});

  final falsePadding = 8.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<AddProductModalViewController>(
      init: AddProductModalViewController(),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.only(
            left: falsePadding.value,
            right: 8,
            bottom: 20,
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 70.ph,
                  child: ListView(
                    children: [
                      8.height,
                      FBString(
                        textController: controller.nameController,
                        label: 'product_name'.tr,
                        //example: 'sample_name'.tr,
                        hint: 'product_name'.tr,
                        errorMsg: 'product_name_required'.tr,
                        isRequired: true,
                      ),
                      0.height,
                      AdvanceSelect(
                        isRequired: true,
                        controller: controller.categoryManager.asController,
                        hint: 'select_category'.tr,
                        isShowSearch: false,
                        itemToString: (data) => data?.name ?? '',
                        label: 'category'.tr,
                        errorMsg: 'category_required'.tr,
                      ),
                      0.height,
                      AdvanceSelect(
                        isRequired: true,
                        controller: controller.brandManager.asController,
                        hint: 'select_brand'.tr,
                        isShowSearch: false,
                        itemToString: (data) => data?.name ?? '',
                        label: 'brand'.tr,
                        errorMsg: 'brand_required'.tr,
                      ),
                      0.height,
                      FBString(
                        textController: controller.modelNumberController,
                        label: 'model_number'.tr,
                        //example: 'sample_model'.tr,
                        hint: 'model_number'.tr,
                        isRequired: false,
                        errorMsg: '',
                      ),
                      0.height,
                      AdvanceSelect(
                        isRequired: true,
                        controller: controller.unitManager.asController,
                        hint: 'choose_unit'.tr,
                        isShowSearch: false,
                        itemToString: (data) => data?.name ?? '',
                        label: 'unit'.tr,
                        errorMsg: 'unit_required'.tr,
                      ),
                      0.height,
                      Row(
                        children: [
                          Expanded(
                            child: FBString(
                              textController:
                                  controller.purchasePriceController,
                              keyboardType: number,
                              preFixIcon: TablerIcons.coin,
                              label: 'purchase_price'.tr,
                              //example: '0.00'.tr,
                              hint: 'price'.tr,
                              errorMsg: 'purchase_price_required'.tr,
                              isRequired: true,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          2.percentWidth,
                          Expanded(
                            child: FBString(
                              textController: controller.salePriceController,
                              preFixIcon: TablerIcons.coin,
                              label: 'sales_price'.tr,
                              hint: 'price'.tr,
                              //example: "0.00",
                              errorMsg: 'sales_price_required'.tr,
                              isRequired: true,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      0.height,
                      Row(
                        children: [
                          Expanded(
                            child: FBString(
                              textController: controller.discountController,
                              keyboardType: number,
                              preFixIcon: TablerIcons.coin,
                              label: 'discount_price'.tr,
                              //example: '0.00'.tr,
                              hint: 'price'.tr,
                              errorMsg: '',
                              isRequired: false,
                            ),
                          ),
                        ],
                      ),
                      0.height,
                      Row(
                        children: [
                          Expanded(
                            child: FBString(
                              textController: controller.minimumQtyController,
                              keyboardType: number,
                              label: 'minimum_qty'.tr,
                              //example: '0'.tr,
                              hint: 'qty'.tr,
                              errorMsg: 'mini_quantity_required'.tr,
                              isRequired: true,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          2.percentWidth,
                          Expanded(
                            child: FBString(
                              textController: controller.openingQtyController,
                              keyboardType: number,
                              label: 'opening_qty'.tr,
                              hint: 'qty'.tr,
                              errorMsg: '',
                              isRequired: false,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      0.height,
                      FBString(
                        textController: controller.descriptionController,
                        isRequired: false,
                        lines: 3,
                        label: 'description'.tr,
                        hint: 'description'.tr,
                      ),
                      8.height,
                    ],
                  ),
                ),
                Row(
                  children: [
                    RowButton(
                      buttonName: 'reset'.tr,
                      onTap: controller.onResetTap,
                      leftIcon: TablerIcons.restore,
                    ),
                    2.percentWidth,
                    RowButton(
                      buttonName: 'save'.tr,
                      onTap: controller.onSaveTap,
                      leftIcon: TablerIcons.device_floppy,
                    ),
                  ],
                ),
                // 6.percentHeight,
              ],
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

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/advance_select/advance_select_view.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/fb_string.dart';
import '/app/core/widget/row_button.dart';
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
                  height: 68.ph,
                  child: ListView(
                    children: [
                      8.height,
                      FBString(
                        textController: controller.nameController,
                        label: appLocalization.productName,
                        hint: appLocalization.productName,
                        errorMsg: appLocalization.productNameRequired,
                        isRequired: true,
                      ),
                      0.height,
                      AdvanceSelect(
                        isRequired: false,
                        controller: controller.categoryManager.asController,
                        hint: appLocalization.selectCategory,
                        isShowSearch: false,
                        itemToString: (data) => data?.name ?? '',
                        label: appLocalization.category,
                        errorMsg: appLocalization.categoryRequired,
                      ),
                      0.height,
                      AdvanceSelect(
                        isRequired: false,
                        controller: controller.brandManager.asController,
                        hint: appLocalization.selectBrand,
                        isShowSearch: false,
                        itemToString: (data) => data?.name ?? '',
                        label: appLocalization.brand,
                        errorMsg: appLocalization.brandRequired,
                      ),
                      0.height,
                      FBString(
                        textController: controller.modelNumberController,
                        label: appLocalization.modelNumber,
                        hint: appLocalization.modelNumber,
                        isRequired: false,
                        errorMsg: '',
                      ),
                      0.height,
                      AdvanceSelect(
                        isRequired: true,
                        controller: controller.unitManager.asController,
                        hint: appLocalization.chooseUnit,
                        isShowSearch: false,
                        itemToString: (data) => data?.name ?? '',
                        label: appLocalization.unit,
                        errorMsg: appLocalization.unitRequired,
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
                              label: appLocalization.purchasePrice,
                              hint: appLocalization.price,
                              errorMsg: appLocalization.purchasePriceRequired,
                              isRequired: true,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          2.percentWidth,
                          Expanded(
                            child: FBString(
                              textController: controller.salePriceController,
                              keyboardType: number,
                              preFixIcon: TablerIcons.coin,
                              label: appLocalization.salesPrice,
                              hint: appLocalization.price,
                              errorMsg: appLocalization.salesPriceRequired,
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
                              label: appLocalization.discountPrice,
                              hint: appLocalization.price,
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
                              label: appLocalization.minimumQty,
                              hint: appLocalization.qty,
                              errorMsg: appLocalization.requiredField,
                              isRequired: false,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          2.percentWidth,
                          Expanded(
                            child: FBString(
                              textController: controller.openingQtyController,
                              keyboardType: number,
                              label: appLocalization.openingQty,
                              hint: appLocalization.qty,
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
                        label: appLocalization.description,
                        hint: appLocalization.description,
                      ),
                      8.height,
                    ],
                  ),
                ),
                Row(
                  children: [
                    RowButton(
                      buttonName: appLocalization.reset,
                      onTap: controller.onResetTap,
                      leftIcon: TablerIcons.restore,
                      isOutline: true,
                    ),
                    2.percentWidth,
                    if (controller.isEdit.value)
                      RowButton(
                        buttonName: appLocalization.save,
                        onTap: controller.onEditTap,
                        leftIcon: TablerIcons.device_floppy,
                      ),
                    if (!controller.isEdit.value)
                      RowButton(
                        buttonName: appLocalization.save,
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

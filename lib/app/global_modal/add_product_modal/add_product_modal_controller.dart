import 'package:flutter/material.dart';
import '/app/core/base/base_controller.dart';
import '/app/entity/category.dart';

class AddProductModalViewController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final categoryManager = CategoryManager();
  final brandManager = CategoryManager();
  final unitManager = CategoryManager();
  final nameController = TextEditingController();
  final modelNumberController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final salePriceController = TextEditingController();
  final discountController = TextEditingController();
  final minimumQtyController = TextEditingController();
  final openingQtyController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    await categoryManager.fillAsController();
    await brandManager.fillAsController();
    await unitManager.fillAsController();
  }

  void onResetTap() {
    categoryManager.asController.selectedValue = null;
    brandManager.asController.selectedValue = null;
    unitManager.asController.selectedValue = null;

    nameController.clear();
    modelNumberController.clear();
    purchasePriceController.clear();
    salePriceController.clear();
    discountController.clear();
    minimumQtyController.clear();
    openingQtyController.clear();
    descriptionController.clear();
  }

  Future<void> onSaveTap() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final productName = nameController.text;
    final category = categoryManager.asController.selectedValue?.name;
    final brand = brandManager.asController.selectedValue?.name;
    final unit = unitManager.asController.selectedValue?.name;
    final modelNumber = modelNumberController.text;
    final purchasePrice = purchasePriceController.text;
    final salesPrice = salePriceController.text;
    final discountPrice = discountController.text;
    final minimumQty = minimumQtyController.text;
    final openingQty = openingQtyController.text;
    final description = descriptionController.text;

    await dataFetcher(
      future: () async {
        final value = await services.addStock(
          productName: productName,
          category: category!,
          brand: brand!,
          modelNumber: modelNumber,
          unit: unit!,
          purchasePrice: purchasePrice,
          salesPrice: salesPrice,
          discountPrice: discountPrice,
          minimumQty: minimumQty,
          openingQty: openingQty,
          description: description,
        );

        if (value != null) {
          onResetTap();
          //Get.back();
        }
      },
    );
  }
}

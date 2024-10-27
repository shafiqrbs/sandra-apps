import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/bindings/initial_binding.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/widget/show_snackbar.dart';
import '/app/entity/brand.dart';
import '/app/entity/category.dart';
import '/app/entity/stock.dart';
import '/app/entity/unit.dart';

class AddProductModalViewController extends BaseController {
  final formKey = GlobalKey<FormState>();

  final categoryManager = CategoryManager();
  final brandManager = BrandManager();
  final unitManager = UnitManager();
  final nameController = TextEditingController();
  final modelNumberController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final salePriceController = TextEditingController();
  final discountController = TextEditingController();
  final minimumQtyController = TextEditingController();
  final openingQtyController = TextEditingController();
  final descriptionController = TextEditingController();

  Stock? preStock;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      preStock = args['stock'] as Stock?;
      if (kDebugMode) {
        print('preStock: ${preStock?.toJson()}');
      }
    }
    await categoryManager.fillAsController();
    await brandManager.fillAsController();
    await unitManager.fillAsController();

    if (preStock != null) {
      nameController.text = preStock!.name ?? '';
      if (preStock!.categoryId != null) {
        categoryManager.asController.selectedValue =
            categoryManager.asController.items?.firstWhereOrNull(
          (element) => element.categoryId == preStock?.categoryId,
        );
      }
      if (preStock!.brandName != null) {
        brandManager.asController.selectedValue =
            brandManager.asController.items?.firstWhereOrNull(
          (element) => element.name == preStock?.brandName,
        );
      }
      if (preStock!.unit != null) {
        unitManager.asController.selectedValue =
            unitManager.asController.items?.firstWhereOrNull(
          (element) => element.unitId == preStock?.unit.toInt(),
        );
      }
    }
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
    final category = categoryManager.asController.selectedValue?.categoryId;
    final brand = brandManager.asController.selectedValue?.brandId;
    final unit = unitManager.asController.selectedValue?.unitId;
    final modelNumber = modelNumberController.text;
    final purchasePrice = purchasePriceController.text;
    final salesPrice = salePriceController.text;
    final discountPrice = discountController.text;
    final minimumQty = minimumQtyController.text;
    final openingQty = openingQtyController.text;
    final description = descriptionController.text;

    Stock? createdStock;
    await dataFetcher(
      future: () async {
        createdStock = await services.addStock(
          name: productName,
          categoryId: category?.toString(),
          brandId: brand?.toString(),
          modelNumber: modelNumber,
          unitId: unit!.toString(),
          purchasePrice: purchasePrice,
          salesPrice: salesPrice,
          discountPrice: discountPrice,
          minQty: minimumQty,
          openingQty: openingQty,
          description: description,
        );

        if (createdStock != null) {
          await dbHelper.insertList(
            deleteBeforeInsert: false,
            tableName: dbTables.tableStocks,
            dataList: [
              createdStock!.toJson(),
            ],
          );
        }
      },
    );
    if (createdStock != null) {
      onResetTap();
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.save,
      );
    } else {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.failedToCreateProduct,
      );
    }
  }
}

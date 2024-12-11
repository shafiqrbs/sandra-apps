import 'package:flutter/foundation.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/bindings/initial_binding.dart';
import 'package:sandra/app/entity/stock_details.dart';

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
  final isEdit = false.obs;

  StockDetails? preStock;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      preStock = args['stock'] as StockDetails?;
      isEdit.value = preStock != null;
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
      if (preStock!.brandId != null) {
        brandManager.asController.selectedValue =
            brandManager.asController.items?.firstWhereOrNull(
          (element) => element.brandId == preStock?.brandId,
        );
      }
      if (preStock!.unitId != null) {
        unitManager.asController.selectedValue =
            unitManager.asController.items?.firstWhereOrNull(
          (element) => element.unitId.toString() == preStock?.unitId,
        );
      }

      purchasePriceController.text = preStock!.purchasePrice ?? '';
      salePriceController.text = preStock!.salesPrice ?? '';
      minimumQtyController.text = preStock!.minQuantity?.toString() ?? '';
      openingQtyController.text = preStock!.openingQuantity?.toString() ?? '';
      descriptionController.text = preStock!.description ?? '';
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

  Future<void> onEditTap() async {
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

    Stock? updatedStock;
    await dataFetcher(
      future: () async {
        updatedStock = await services.updateStock(
          id: preStock!.id,
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

        if (updatedStock != null) {
          await dbHelper.updateWhere(
            tbl: dbTables.tableStocks,
            data: updatedStock!.toJson(),
            where: 'item_id = ?',
            whereArgs: [updatedStock!.itemId],
          );
        }
      },
    );
    if (updatedStock != null) {
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.update,
      );
    } else {
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.failedToUpdateProduct,
      );
    }
  }
}

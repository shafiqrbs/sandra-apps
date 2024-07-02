import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/model/stock.dart';
import '/app/core/base/base_controller.dart';

class CreateSalesController extends BaseController {
  final searchController = TextEditingController().obs;
  final selectedStock = Rx<Stock?>(null);


  @override
  Future<void> onInit() async {
    super.onInit();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/widget/dialog_pattern.dart';
import 'package:getx_template/app/global_modal/global_filter_modal_view/global_filter_modal_view.dart';
import 'package:getx_template/app/model/stock.dart';
import '/app/core/base/base_controller.dart';

class StockListController extends BaseController {
  final isSearchSelected = false.obs;
  final stockManager = StockManager();

  @override
  Future<void> onInit() async {
    super.onInit();
    await stockManager.paginate();
  }

  Future<void> showFilterModal({
    required BuildContext context,
  }) async {
    final value = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return DialogPattern(
          title: 'title',
          subTitle: 'subTitle',
          child: GlobalFilterModalView(),
        );
      },
    );

    if (value != null) {}
  }
}

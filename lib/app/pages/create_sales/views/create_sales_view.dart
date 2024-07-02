import 'package:flutter/material.dart';

import '/app/core/base/base_view.dart';
import '/app/global_widget/product_search_form.dart';
import '/app/pages/create_sales/controllers/create_sales_controller.dart';

//ignore: must_be_immutable
class CreateSalesView extends BaseView<CreateSalesController> {
  CreateSalesView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ProductSearchForm(
            onSearch: (value) {},
            onClear: () {},
            isShowSuffixIcon: true,
            autoFocus: true,
            selectedStock: controller.selectedStock.value,
            searchController: controller.searchController.value,
          ),
        ],
      ),
    );
  }
}

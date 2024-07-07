import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/domain/customer/customer_details/controllers/customer_details_controller.dart';

//ignore: must_be_immutable
class CustomerDetailsView extends BaseView<CustomerDetailsController> {
  CustomerDetailsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}

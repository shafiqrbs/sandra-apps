import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/base/base_view.dart';
import 'package:sandra/app/global_modal/sync_modal/sync_modal_controller.dart';

class SyncModalView extends BaseView<SyncModalController> {
  final falsePadding = 0.0.obs;
  @override
  Widget build(BuildContext context) {
    return GetX<SyncModalController>(
      init: SyncModalController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(falsePadding.value),
            child: Column(
              children: [
                _buildButton(
                  title: appLocalization.customer,
                  onTap: controller.syncCustomer,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    String title = '',
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: spaceBetweenMAA,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
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

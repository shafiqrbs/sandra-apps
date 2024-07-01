import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/license/controllers/license_controller.dart';

//ignore: must_be_immutable
class LicenseView extends BaseView<LicenseController> {
  LicenseView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildForm(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container();
  }

  Widget _buildForm() {
    return Container();
  }
}

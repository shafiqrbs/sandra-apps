import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/widget/tbd_text_button.dart';
import '/app/core/base/base_view.dart';
import '/app/global_modal/sync_modal/sync_modal_controller.dart';

class SyncModalView extends BaseView<SyncModalController> {
  SyncModalView({super.key});

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
                Row(
                  children: [
                    TbdTextButton(
                      text: appLocalization.dataImport,
                      onPressed: () => controller.changeType(
                        SyncType.import,
                      ),
                      isSelected:
                          controller.selectedSyncType.value == SyncType.import,
                    ),
                    TbdTextButton(
                      text: appLocalization.dataExport,
                      onPressed: () => controller.changeType(
                        SyncType.export,
                      ),
                      isSelected:
                          controller.selectedSyncType.value == SyncType.export,
                    ),
                  ],
                ),
                controller.selectedSyncType.value == SyncType.export
                    ? _exportButtonList()
                    : _importButtonList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _exportButtonList() {
    return Column(
      children: [
        if(kDebugMode)
        _buildButton(
          title: 'Generate sales',
          onTap: controller.generateSales,
        ),
        _buildButton(
          title: appLocalization.sales,
          onTap: controller.exportSales,
        ),
        _buildButton(
          title: appLocalization.purchase,
          onTap: controller.exportPurchase,
        ),
        _buildButton(
          title: appLocalization.expense,
          onTap: controller.exportExpense,
        ),
      ],
    );
  }

  Widget _importButtonList() {
    return Column(
      children: [
        _buildButton(
          title: appLocalization.customer,
          onTap: () {
            controller.changeType(SyncType.import);
          },
        ),
        _buildButton(
          title: appLocalization.sync,
          onTap: controller.sync,
        ),
      ],
    );
  }

  Widget _buildButton({
    String title = '',
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: spaceBetweenMAA,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
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

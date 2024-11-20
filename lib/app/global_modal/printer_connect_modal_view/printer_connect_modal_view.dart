import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import '/app/core/base/base_view.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/widget/row_button.dart';
import '/app/global_widget/shimmer_list_view.dart';
import 'package:nb_utils/nb_utils.dart';

import 'printer_connect_modal_view_controller.dart';

class PrinterConnectModalView
    extends BaseView<PrinterConnectModalViewController> {
  PrinterConnectModalView({super.key});

  final falsePadding = 16.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<PrinterConnectModalViewController>(
      init: PrinterConnectModalViewController(),
      builder: (controller) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(falsePadding.value),
              decoration: BoxDecoration(
                color: colors.whiteColor,
              ),
              child: Column(
                children: [
                  Obx(
                    () {
                      return controller.isLoader.value ||
                              controller.connected.value
                          ? Text(
                            appLocalization.printerIsAlreadyConnected,
                            style: AppTextStyle.h2TextStyle500,
                          )
                          : Column(
                              children: [
                                Obx(
                                  () {
                                    return Text(
                                      controller.msg.value,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  children: [
                                    RowButton(
                                      buttonName: 'scan'.tr,
                                      onTap: controller.getBluetoothList,
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => SizedBox(
                                    height: 40.ph,
                                    child: controller.isConnecting.value
                                        ? ShimmerListView(
                                            itemCount: 1,
                                            msg: appLocalization.connecting,
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .availAbleDevices.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () async {
                                                  if (kDebugMode) {
                                                    print(
                                                      'macAdress: ${controller.availAbleDevices[index].macAdress}',
                                                    );
                                                  }
                                                  final isConnected =
                                                      await controller.connect(
                                                    controller
                                                        .availAbleDevices[index]
                                                        .macAdress,
                                                  );
                                                  if (isConnected) {
                                                    Get.back();
                                                  }
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  margin: const EdgeInsets.only(
                                                    top: 4,
                                                    bottom: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      containerBorderRadius,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        controller
                                                            .availAbleDevices[
                                                                index]
                                                            .name,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      4.width,
                                                      1.percentHeight,
                                                      Text(
                                                        controller
                                                            .availAbleDevices[
                                                                index]
                                                            .macAdress,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

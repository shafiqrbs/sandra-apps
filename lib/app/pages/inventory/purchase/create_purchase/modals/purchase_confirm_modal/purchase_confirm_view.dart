import 'package:sandra/app/core/importer.dart';

import '/app/core/widget/row_button.dart';
import '/app/entity/purchase.dart';
import '/app/global_widget/shimmer_list_view.dart';
import 'purchase_confirm_controller.dart';

class PurchaseConfirmView extends BaseView<PurchaseConfirmController> {
  final Purchase purchase;
  final bool isEdit;

  PurchaseConfirmView({
    required this.purchase,
    required this.isEdit,
    super.key,
  });

  final falsePadding = 16.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<PurchaseConfirmController>(
      init: PurchaseConfirmController(
        purchase: purchase,
        isEdit: isEdit,
      ),
      builder: (controller) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(
                falsePadding.value,
              ),
              decoration: BoxDecoration(
                color: colors.whiteColor,
              ),
              child: Column(
                children: [
                  Obx(
                    () {
                      return controller.isLoader.value ||
                              controller.connected.value ||
                              !controller.hasPrinter.value
                          ? Container()
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
                                8.height,
                                Row(
                                  children: [
                                    RowButton(
                                      buttonName: appLocalization.scan,
                                      onTap: controller.scanBluetooth,
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => SizedBox(
                                    height: 40.ph,
                                    child: controller.isConnecting.value
                                        ? ShimmerListView(
                                            itemCount: 1,
                                            msg: appLocalization.connectPrinter,
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
                                                  await controller.connect(
                                                    controller
                                                        .availAbleDevices[index]
                                                        .macAdress,
                                                  );
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
                  1.percentHeight,
                  Container(
                    margin: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.hasPrinter.value)
                          Obx(
                            () => controller.isLoader.value
                                ? const CircularProgressIndicator(
                                    color: Colors.red,
                                  )
                                : RowButton(
                                    buttonName: appLocalization.print,
                                    onTap: controller.purchasePrint,
                                    leftIcon: TablerIcons.printer,
                                    buttonBGColor: controller.connected.value
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                          ),
                        4.width,
                        RowButton(
                          buttonName: appLocalization.save,
                          onTap: controller.savePurchase,
                          leftIcon: TablerIcons.device_floppy,
                        ),
                      ],
                    ),
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

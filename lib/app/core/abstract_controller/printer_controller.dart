import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/setup.dart';
import '/app/entity/sales.dart';
import '/app/entity/sales_item.dart';

class PrinterController extends BaseController {
  final msg = ''.obs;
  final info = ''.obs;
  final progressMsg = ''.obs;
  final progress = false.obs;

  final availAbleDevices = <BluetoothInfo>[].obs;

  final connected = false.obs;

  final isLoader = true.obs;

  final isConnecting = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoader.value = true;
    await getBluetoothPermission();
    await initPlatformState();
    isLoader.value = false;
  }

  Future<void> getBluetoothPermission() async {
    if (kDebugMode) {
      print('getBluetoothPermission');
    }
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    if (await Permission.location.isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
  }

  Future<void> initPlatformState() async {
    if (kDebugMode) {
      print('initPlatformState');
    }
    String platformVersion;
    int batteryPercent = 0;
    try {
      if (kDebugMode) {
        print('i am getting platform version');
      }
      platformVersion = await PrintBluetoothThermal.platformVersion;
      if (kDebugMode) {
        print('platform version : $platformVersion');
      }
      batteryPercent = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    await PrintBluetoothThermal.isPermissionBluetoothGranted;
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    if (kDebugMode) {
      print('bluetooth enabled: $result');
    }
    if (result) {
      msg.value = 'Bluetooth enabled, please search and connect';
    } else {
      msg.value = 'Bluetooth not enabled';
    }

    info.value = '$platformVersion ($batteryPercent% battery)';

    // check if there is any connected printer
    final bool preConnected = await PrintBluetoothThermal.connectionStatus;
    if (preConnected) {
      progressMsg.value = 'Connected';
      connected.value = true;
      // get the connected printer info
    } else {
      progressMsg.value = 'Not connected';
      connected.value = false;
    }
  }

  Future<void> getBluetoothList() async {
    // check blutooth status
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    if (!result) {
      msg.value = 'Bluetooth not enabled';
      return;
    }

    progress.value = true;
    progressMsg.value = 'Wait';
    availAbleDevices.value = [];

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    progress.value = false;

    if (listResult.isEmpty) {
      msg.value =
          'There are no bluetooth linked, go to settings and link the printer';
    } else {
      msg.value = 'Touch an item in the list to connect';
    }

    availAbleDevices.value = listResult;
  }

  Future<bool> connect(String mac) async {
    progress.value = true;
    progressMsg.value = 'Connecting...';
    connected.value = false;
    isConnecting.value = true;

    await disconnect();

    if (kDebugMode) {
      print(mac);
    }
    if (kDebugMode) {
      print(await PrintBluetoothThermal.pairedBluetooths);
    }

    final bool result = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    if (kDebugMode) {
      print('state connected $result');
    }

    connected.value = result;
    progress.value = false;

    if (connected.value) {
      progressMsg.value = 'Connected';
    } else {
      progressMsg.value = 'Failed to connect';
      toast('Failed to connect');
    }

    isConnecting.value = false;

    return connected.value;
  }

  Future<bool> printSales(Purchase sales) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final data = await templateOne(sales: sales);
      return PrintBluetoothThermal.writeBytes(data); // init
    } else {
      toast('please_connect_printer'.tr);
      return false;
    }
  }

  //disconnect the connected printer
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    connected.value = false;
  }

  Future<List<int>> templateOne({required Purchase sales}) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();

    final paperType = await prefs.getPrintPaperType();

    final generator = Generator(
      paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data =
        await rootBundle.load('assets/images/cover_poster_3.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    final img.Image? image = img.decodeImage(bytesImg);

    if (Platform.isIOS) {
      // Resizes the image to half its original size and reduces the quality to 80%
      final resizedImage = img.copyResize(
        image!,
        width: image.width ~/ 1.3,
        height: image.height ~/ 1.3,
      );
      final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
      //image = img.decodeImage(bytesimg);
    }

// Add shop name
    bytes += generator.text(
      SetUp().name ?? '',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      SetUp().address ?? '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: '${"bill".tr}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.invoice ?? '',
          width: 4,
        ),
        PosColumn(
          text: '${"sales".tr}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.salesId ?? '',
          width: 4,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: '${"date".tr}: ',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: sales.createdAt.toString(),
          width: 4,
        ),
        PosColumn(
          text: '${"mode".tr}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: ' Now it empty ',
          width: 4,
        ),
      ],
    );
    bytes += generator.feed(1);

    // Add table headers
    bytes += generator.row(
      [
        PosColumn(
          text: 'item_name'.tr,
          width: 7,
        ),
        PosColumn(
          text: 'rate'.tr,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'qty'.tr,
          width: 1,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'total'.tr,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.text('------------------------------------------------');

    if (sales.salesItem != null && sales.salesItem!.isNotEmpty) {
      for (final SalesItem rowData in sales.salesItem!) {
        bytes += generator.row(
          [
            PosColumn(
              text: rowData.stockName ?? '',
              width: 7,
            ),
            PosColumn(
              text: rowData.salesPrice?.toString() ?? '',
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: rowData.quantity?.toString() ?? '',
              width: 1,
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: rowData.subTotal.toString() ?? '',
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
          ],
        );
      }
    }
    bytes += generator.text('------------------------------------------------');
    bytes += generator.row([
      PosColumn(
        text: 'sub_total'.tr,
        width: 9,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: 'Tk',
        width: 1,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: sales.subTotal?.toString() ?? '',
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    if (sales.discountType == 'percent') {
      bytes += generator.row(
        [
          PosColumn(
            text:
                '${"discount".tr} (${sales.discountCalculation?.toString() ?? 0}%)',
            width: 9,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
          PosColumn(
            text: 'Tk',
            width: 1,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: sales.discount?.toString() ?? '',
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ],
      );
    } else {
      bytes += generator.row([
        PosColumn(
          text: 'discount'.tr,
          width: 9,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: 'Tk',
          width: 1,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: sales.discount?.toString() ?? '',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }
    bytes += generator.text('------------------------------------------------');
    bytes += generator.row([
      PosColumn(
        text: 'net_payable'.tr,
        width: 9,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: 'Tk',
        width: 1,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: sales.netTotal?.toString() ?? '',
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    bytes += generator.row(
      [
        PosColumn(
          text: 'paid',
          width: 9,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: 'Tk',
          width: 1,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: sales.received?.toString() ?? '',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.feed(1);

    //bytes += generator.text(SetUp().printFooter ?? '');
    bytes += generator.feed(1);
    bytes += generator.text(
      SetUp().website ?? 'TerminalBd.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    return bytes;
  }
}

import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sandra/app/core/widget/show_snackbar.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/customer_ledger.dart';
import 'package:sandra/app/entity/vendor.dart';
import 'package:sandra/app/entity/vendor_ledger.dart';
import 'package:sandra/app/pdf_views/pos_functions.dart';

import '/app/core/base/base_controller.dart';
import '/app/core/core_model/setup.dart';
import '/app/entity/purchase.dart';
import '/app/entity/purchase_item.dart';
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

  int newLine = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoader.value = true;
    await getBluetoothPermission();
    await initPlatformState();
    isLoader.value = false;
    newLine = await prefs.getNumberOfPrinterNewLine();
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
      msg.value = appLocalization.bluetoothConnectionUnavailable;
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
      showSnackBar(
        type: SnackBarType.error,
        message: appLocalization.connectionFailed,
      );
    }

    isConnecting.value = false;

    return connected.value;
  }

  Future<bool> printSales(
    Sales sales,
  ) async {
    try{
      final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
      if (connectionStatus) {
        final data = await templateOne(sales: sales);
        return PrintBluetoothThermal.writeBytes(data); // init
      } else {
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.connectPrinter,
        );
        return false;
      }
    } catch(e,err){
      print('Error in print: $e, $err');
      return false;
    }
  }

  Future<bool> printRestaurantKitchen({
    required Sales sales,
    required String table,
    required String orderTakenBy,
  }) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final data = await kitchenTemplateOne(
        sales: sales,
        table: table,
        orderTakenBy: orderTakenBy,
      );
      return PrintBluetoothThermal.writeBytes(data); // init
    } else {
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.connectPrinter,
      );
      return false;
    }
  }

  Future<bool> printRestaurantToken({
    required Sales sales,
    required String table,
    required String orderTakenBy,
  }) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final data = await tokenTemplateOne(
        sales: sales,
        table: table,
        orderTakenBy: orderTakenBy,
      );
      return PrintBluetoothThermal.writeBytes(data); // init
    } else {
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.connectPrinter,
      );
      return false;
    }
  }

  Future<bool> printPurchase(
    Purchase purchase,
  ) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final data = await purchaseTemplateOne(
        purchase: purchase,
      );
      return PrintBluetoothThermal.writeBytes(data); // init
    } else {
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.connectPrinter,
      );
      return false;
    }
  }

  Future<void> printCustomerLedger({
    required List<CustomerLedger> ledger,
    required Customer customer,
  }) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final data = await PosTemplate().customerLedgerTemplate(
        ledger: ledger,
        customer: customer,
      );
      await PrintBluetoothThermal.writeBytes(data); // init
    } else {
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.connectPrinter,
      );
    }
  }

  Future<void> printVendorLedger({
    required List<VendorLedger> ledger,
    required Vendor vendor,
  }) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final data = await PosTemplate().vendorLedgerTemplate(
        ledger: ledger,
        vendor: vendor,
      );
      await PrintBluetoothThermal.writeBytes(data); // init
    } else {
      showSnackBar(
        type: SnackBarType.success,
        message: appLocalization.connectPrinter,
      );
    }
  }

  //disconnect the connected printer
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    connected.value = false;
  }

  Future<List<int>> templateOne({
    required Sales sales,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final paperType = await prefs.getPrintPaperType();

    final generator = Generator(
      paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );

    /*   bytes += generator.reset();

    final ByteData data = await rootBundle.load(
      'assets/images/cover_poster_3.jpg',
    );
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
    }*/

// Add shop name
    bytes += generator.text(
      isEnglish(SetUp().name ?? '') ? SetUp().name ?? '' : '',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      isEnglish(SetUp().address ?? '') ? SetUp().address ?? '' : '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.text(
      isEnglish(SetUp().address ?? '') ? SetUp().address ?? '' : '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: 'Bill: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.invoice ?? '',
          width: 4,
        ),
        PosColumn(
          text: 'Sales By: ',
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
          text: 'Cus: ',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: sales.customerName ?? '',
          width: 4,
        ),
        PosColumn(
          text: 'Mob: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.customerMobile ?? '',
          width: 4,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'Date: ',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: sales.createdAt ?? '',
          width: 4,
        ),
        PosColumn(
          text: 'Mode: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.methodMode ?? '',
          width: 4,
        ),
      ],
    );

    bytes += generator.feed(1);

    // Add table headers
    bytes += generator.row(
      [
        PosColumn(
          text: 'Item Name',
          width: 7,
        ),
        PosColumn(
          text: 'Rate',
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Qty',
          width: 1,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Total',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.text('------------------------------------------------');

    print(sales.salesItem!.length);

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
        text: appLocalization.subTotal,
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
                '${appLocalization.discount} (${sales.discountCalculation?.toString() ?? 0}%)',
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
          text: 'Discount',
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
        text: appLocalization.netPayable,
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

    bytes += generator.text(
      SetUp().printFooter ?? '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    //bytes += generator.text(SetUp().printFooter ?? '');
    // TODO: do it dynamic
    bytes += generator.feed(newLine);
    bytes += generator.text(
      SetUp().website ?? 'poskeeper.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> kitchenTemplateOne({
    required Sales sales,
    required String table,
    required String orderTakenBy,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final paperType = await prefs.getPrintPaperType();

    final generator = Generator(
      paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );

// Add shop name
    bytes += generator.text(
      'Kitchen',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      isEnglish(SetUp().name ?? '') ? SetUp().name ?? '' : '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: '${appLocalization.table}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: table,
          width: 4,
        ),
        PosColumn(
          text: '${appLocalization.orderTakenBy}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: orderTakenBy,
          width: 4,
        ),
      ],
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
          text: '${appLocalization.sales}: ',
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
          text: 'Item Name',
          width: 7,
        ),
        PosColumn(
          text: 'Qty',
          width: 1,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
      ],
    );
    bytes += generator.text('------------------------------------------------');

    print(sales.salesItem!.length);

    if (sales.salesItem != null && sales.salesItem!.isNotEmpty) {
      for (final SalesItem rowData in sales.salesItem!) {
        bytes += generator.row(
          [
            PosColumn(
              text: rowData.stockName ?? '',
              width: 7,
            ),
            PosColumn(
              text: rowData.quantity?.toString() ?? '',
              width: 1,
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
          ],
        );
      }
    }

    bytes += generator.text(
      SetUp().printFooter ?? '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    //bytes += generator.text(SetUp().printFooter ?? '');
    // TODO: do it dynamic
    bytes += generator.feed(newLine);
    bytes += generator.text(
      SetUp().website ?? 'poskeeper.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> tokenTemplateOne({
    required Sales sales,
    required String table,
    required String orderTakenBy,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final paperType = await prefs.getPrintPaperType();

    final generator = Generator(
      paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );

// Add shop name
    bytes += generator.text(
      'Token',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      isEnglish(SetUp().name ?? '') ? SetUp().name ?? '' : '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: '${appLocalization.table}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: table,
          width: 4,
        ),
        PosColumn(
          text: '${appLocalization.orderTakenBy}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: orderTakenBy,
          width: 4,
        ),
      ],
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
          text: '${appLocalization.sales}: ',
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

    bytes += generator.text('------------------------------------------------');

    bytes += generator.text(
      'Token No: ${sales.tokenNo}',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size3,
        align: PosAlign.center,
      ),
    );

    bytes += generator.text(
      SetUp().printFooter ?? '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    //bytes += generator.text(SetUp().printFooter ?? '');
    // TODO: do it dynamic
    bytes += generator.feed(newLine);
    bytes += generator.text(
      SetUp().website ?? 'poskeeper.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> purchaseTemplateOne({
    required Purchase purchase,
  }) async {
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

    final ByteData data = await rootBundle.load(
      'assets/images/cover_poster_3.jpg',
    );
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
      isEnglish(SetUp().name ?? '') ? SetUp().name ?? '' : '',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      isEnglish(SetUp().address ?? '') ? SetUp().address ?? '' : '',
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
          text: purchase.invoice ?? '',
          width: 4,
        ),
        PosColumn(
          text: '${"sales".tr}: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: purchase.purchaseId ?? '',
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
          text: purchase.createdAt.toString(),
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
          text: 'Item Name',
          width: 7,
        ),
        PosColumn(
          text: 'Rate',
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Qty',
          width: 1,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Total',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.text('------------------------------------------------');

    if (purchase.purchaseItem != null && purchase.purchaseItem!.isNotEmpty) {
      for (final PurchaseItem rowData in purchase.purchaseItem!) {
        bytes += generator.row(
          [
            PosColumn(
              text: rowData.stockName ?? '',
              width: 7,
            ),
            PosColumn(
              text: rowData.price?.toString() ?? '',
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
        text: appLocalization.subTotal,
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
        text: purchase.subTotal?.toString() ?? '',
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.text('------------------------------------------------');
    bytes += generator.row([
      PosColumn(
        text: 'Net Payable',
        width: 9,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: 'Tk',
        width: 1,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: purchase.netTotal?.toString() ?? '',
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
          text: purchase.received?.toString() ?? '',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.feed(1);

    bytes += generator.text(
      SetUp().printFooter ?? '',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    //bytes += generator.text(SetUp().printFooter ?? '');
    bytes += generator.feed(1);
    bytes += generator.text(
      SetUp().website ?? 'poskeeper.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }

  bool isEnglish(String input) {
    final regex = RegExp(r'^[\x00-\x7F]+$');
    return regex.hasMatch(input);
  }
}

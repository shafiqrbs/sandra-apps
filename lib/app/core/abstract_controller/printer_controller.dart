import 'dart:io';
import 'dart:ui' as ui;

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sandra/app/core/widget/show_snack_bar.dart';
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
    Sales sales, {
    bool useImageBasedPrinting = true,
    double shopNameFontSize = 20.0,
    double itemFontSize = 12.0,
    double totalFontSize = 14.0,
  }) async {
    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (connectionStatus) {
        if (useImageBasedPrinting) {
          // Use new image-based printing with font control
          return await printSalesWithImageControl(
            sales,
            shopNameFontSize: shopNameFontSize,
            itemFontSize: itemFontSize,
            totalFontSize: totalFontSize,
          );
        } else {
          // Use legacy ESC/POS printing
          final data = await templateOne(sales: sales);
          return PrintBluetoothThermal.writeBytes(data);
        }
      } else {
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.connectPrinter,
        );
        return false;
      }
    } catch (e, err) {
      if (kDebugMode) {
        print('Error in print: $e, $err');
      }
      return false;
    }
  }

  Future<bool> printSalesWithoutInvoice(
    CustomerLedger ledger, {
    bool useImageBasedPrinting = true,
    double headerFontSize = 18.0,
    double contentFontSize = 12.0,
  }) async {
    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (connectionStatus) {
        if (useImageBasedPrinting) {
          return await _printSalesWithoutInvoiceImageBased(
            ledger,
            headerFontSize: headerFontSize,
            contentFontSize: contentFontSize,
          );
        } else {
          final data = await salesWithoutInvoiceTemplateOne(ledger: ledger);
          return PrintBluetoothThermal.writeBytes(data);
        }
      } else {
        showSnackBar(
          type: SnackBarType.success,
          message: appLocalization.connectPrinter,
        );
        return false;
      }
    } catch (e, err) {
      print('Error in print: $e, $err');
      return false;
    }
  }

  Future<bool> printRestaurantKitchen({
    required Sales sales,
    required String table,
    required String orderTakenBy,
    bool useImageBasedPrinting = true,
    double headerFontSize = 18.0,
    double itemFontSize = 14.0,
  }) async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      if (useImageBasedPrinting) {
        return await _printKitchenImageBased(
          sales: sales,
          table: table,
          orderTakenBy: orderTakenBy,
          headerFontSize: headerFontSize,
          itemFontSize: itemFontSize,
        );
      } else {
        final data = await kitchenTemplateOne(
          sales: sales,
          table: table,
          orderTakenBy: orderTakenBy,
        );
        return PrintBluetoothThermal.writeBytes(data);
      }
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

  // ==================== IMAGE-BASED PRINTING METHODS ====================

  /// Generate text as image for precise font control
  Future<img.Image> generateTextImage(
    String text, {
    double fontSize = 12.0,
    bool isBold = false,
    TextAlign textAlign = TextAlign.left,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.white,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Thermal printer width (384 pixels for 58mm, 576 for 80mm)
    final paperType = await prefs.getPrintPaperType();
    final double width = paperType == '58 mm' ? 384 : 576;
    final double height = fontSize * 2.5; // More height for complex scripts

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = backgroundColor,
    );

    // Create text painter
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textColor,
        ),
      ),
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: width - 20); // 10px padding on each side

    // Calculate vertical centering
    final double yOffset = (height - textPainter.height) / 2;

    // Calculate horizontal alignment
    double xOffset = 10; // Default left padding
    if (textAlign == TextAlign.center) {
      xOffset = (width - textPainter.width) / 2;
    } else if (textAlign == TextAlign.right) {
      xOffset = width - textPainter.width - 10;
    }

    // Draw text
    textPainter.paint(canvas, Offset(xOffset, yOffset));

    final picture = recorder.endRecording();
    final uiImage = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

    // Convert to img.Image for ESC/POS processing
    final pngBytes = byteData!.buffer.asUint8List();
    final image = img.decodeImage(pngBytes);

    return image!;
  }

  /// Print custom text with specific font size
  Future<bool> printCustomText(
    String text, {
    double fontSize = 12.0,
    bool isBold = false,
    TextAlign textAlign = TextAlign.left,
    bool addFeedAfter = true,
  }) async {
    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (!connectionStatus) {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.connectPrinter,
        );
        return false;
      }

      // Generate text as image
      final image = await generateTextImage(
        text,
        fontSize: fontSize,
        isBold: isBold,
        textAlign: textAlign,
      );

      // Create print data
      final profile = await CapabilityProfile.load();
      final paperType = await prefs.getPrintPaperType();
      final generator = Generator(
        paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];
      bytes += generator.image(image);
      if (addFeedAfter) bytes += generator.feed(1);

      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      if (kDebugMode) print('Error in printCustomText: $e');
      return false;
    }
  }

  /// Print multiple lines with different font sizes
  Future<bool> printMultiSizeText(List<Map<String, dynamic>> textLines) async {
    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (!connectionStatus) {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.connectPrinter,
        );
        return false;
      }

      final profile = await CapabilityProfile.load();
      final paperType = await prefs.getPrintPaperType();
      final generator = Generator(
        paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];

      for (final line in textLines) {
        final String text = line['text'] ?? '';
        final double fontSize = line['fontSize']?.toDouble() ?? 12.0;
        final bool isBold = line['isBold'] ?? false;
        final TextAlign textAlign = line['textAlign'] ?? TextAlign.left;
        final bool addSpace = line['addSpace'] ?? true;

        if (text.isNotEmpty) {
          final image = await generateTextImage(
            text,
            fontSize: fontSize,
            isBold: isBold,
            textAlign: textAlign,
          );
          bytes += generator.image(image);
          if (addSpace) bytes += generator.feed(1);
        }
      }

      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      if (kDebugMode) print('Error in printMultiSizeText: $e');
      return false;
    }
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
      'Invoice : ${sales.invoice}',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: 'Date: ${sales.createdAt ?? ''}',
          width: 7,
        ),
        PosColumn(
          text: 'Mode: ${sales.methodName ?? ''}',
          width: 5,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'Cus : ${sales.customerName ?? ''}',
          width: 7,
        ),
        PosColumn(
          text: 'Mob : ${sales.customerMobile ?? ''}',
          width: 5,
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

    if (kDebugMode) {
      print(sales.salesItem!.length);
    }

    if (sales.salesItem != null && sales.salesItem!.isNotEmpty) {
      int index = 1;
      for (final SalesItem rowData in sales.salesItem!) {
        bytes += generator.row(
          [
            PosColumn(
              text: '${index++}.${rowData.stockName ?? ''}',
              width: 7,
            ),
            PosColumn(
              text: rowData.salesPrice?.toString() ?? '',
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: rowData.quantity != null
                  ? rowData.quantity!.toStringAsFixed(0)
                  : '1',
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
    bytes += generator.row(
      [
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
          text: sales.subTotal?.toInt().toString() ?? '',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
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
            text: sales.discount?.toInt().toString() ?? '',
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
          text: sales.discount?.toInt().toString() ?? '',
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
        text: sales.netTotal?.round().toString() ?? '',
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    bytes += generator.row(
      [
        PosColumn(
          text: 'Paid',
          width: 9,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: 'Tk',
          width: 1,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: sales.received?.round().toString() ?? '',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    if (sales.due != null && sales.due! > 0) {
      bytes += generator.row(
        [
          PosColumn(
            text: appLocalization.due,
            width: 9,
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: 'Tk',
            width: 1,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: sales.due?.toInt().toString() ?? '',
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ],
      );
    }
    bytes += generator.text('------------------------------------------------');

    bytes += generator.text(
      'Sales By: ${sales.salesBy ?? 'N/A'}',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += generator.feed(1);

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

  Future<List<int>> salesWithoutInvoiceTemplateOne({
    required CustomerLedger ledger,
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
      'Receipt Print',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: 'Invoice: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 4,
        ),
        PosColumn(
          text: ledger.invoice ?? '',
          width: 8,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'Date: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 4,
        ),
        PosColumn(
          text: ledger.created ?? '',
          width: 8,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'Customer: ',
          styles: const PosStyles(align: PosAlign.right),
          width: 4,
        ),
        PosColumn(
          text: ledger.customerName ?? '',
          width: 8,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: 'Mobile: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 4,
        ),
        PosColumn(
          text: ledger.mobile ?? '',
          width: 8,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: 'Method: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
          width: 4,
        ),
        PosColumn(
          text: ledger.method ?? 'N/A',
          width: 8,
        ),
      ],
    );

    bytes += generator.feed(1);

    bytes += generator.text('------------------------------------------------');

    bytes += generator.row([
      PosColumn(
        text: 'Received',
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
        text: ledger.amount?.toString() ?? '',
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.text('------------------------------------------------');

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

    bytes += generator.text('------------------------------------------------');

    bytes += generator.text(
      'Token No: ${sales.tokenNo}',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size1,
        align: PosAlign.center,
      ),
    );

    bytes += generator.text('------------------------------------------------');

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
          text: 'Bill: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.invoice ?? '',
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
          text: sales.createdAt.toString(),
          width: 10,
        ),
      ],
    );

    bytes += generator.row(
      [
        PosColumn(
          text: '${appLocalization.orderTakenBy}: ',
          width: 3,
        ),
        PosColumn(
          text: orderTakenBy,
          width: 9,
        ),
      ],
    );

    bytes += generator.feed(1);

    // Add table headers
    bytes += generator.row(
      [
        PosColumn(
          text: 'Item Name',
          width: 10,
        ),
        PosColumn(
          text: 'Qty',
          width: 2,
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
              width: 10,
            ),
            PosColumn(
              text: rowData.quantity?.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
          ],
        );
      }
    }

    bytes += generator.feed(1);

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
          text: 'Bill: ',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: sales.invoice ?? '',
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
          text: sales.createdAt.toString(),
          width: 10,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: '${appLocalization.orderTakenBy}: ',
          width: 3,
        ),
        PosColumn(
          text: orderTakenBy,
          width: 9,
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

    bytes += generator.feed(1);

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
    bytes += generator.row(
      [
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
      ],
    );
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

  /// Enhanced sales template with image-based printing for font control
  Future<bool> printSalesWithImageControl(
    Sales sales, {
    double shopNameFontSize = 20.0,
    double itemFontSize = 12.0,
    double totalFontSize = 14.0,
  }) async {
    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (!connectionStatus) {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.connectPrinter,
        );
        return false;
      }

      final profile = await CapabilityProfile.load();
      final paperType = await prefs.getPrintPaperType();
      final generator = Generator(
        paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];
      bytes += generator.reset();

      // Shop name with custom font size
      final shopNameImage = await generateTextImage(
        SetUp().name ?? '',
        fontSize: shopNameFontSize,
        isBold: true,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(shopNameImage);

      // Address
      final addressImage = await generateTextImage(
        SetUp().address ?? '',
        fontSize: 12.0,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(addressImage);
      bytes += generator.feed(1);

      // Invoice with custom font size
      final invoiceImage = await generateTextImage(
        'Invoice : ${sales.invoice}',
        fontSize: 16.0,
        isBold: true,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(invoiceImage);
      bytes += generator.feed(1);

      // Date and Mode
      bytes += generator.row([
        PosColumn(text: 'Date: ${sales.createdAt ?? ''}', width: 7),
        PosColumn(text: 'Mode: ${sales.methodName ?? ''}', width: 5),
      ]);

      // Customer info
      bytes += generator.row([
        PosColumn(text: 'Cus : ${sales.customerName ?? ''}', width: 7),
        PosColumn(text: 'Mob : ${sales.customerMobile ?? ''}', width: 5),
      ]);

      bytes += generator.feed(1);

      // Table headers
      bytes += generator.row([
        PosColumn(text: 'Item Name', width: 7),
        PosColumn(
            text: 'Rate', styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
            text: 'Qty',
            width: 1,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
            text: 'Total', styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes +=
          generator.text('------------------------------------------------');

      // Items with custom font size
      if (sales.salesItem != null && sales.salesItem!.isNotEmpty) {
        int index = 1;
        for (final SalesItem rowData in sales.salesItem!) {
          // Use image-based printing for item names to support Unicode
          final itemNameImage = await generateTextImage(
            '${index++}.${rowData.stockName ?? ''}',
            fontSize: itemFontSize,
          );
          bytes += generator.image(itemNameImage);

          // Regular row for price, qty, total
          bytes += generator.row([
            PosColumn(text: '', width: 7), // Empty space for item name
            PosColumn(
              text: rowData.salesPrice?.toString() ?? '',
              styles: const PosStyles(align: PosAlign.center),
            ),
            PosColumn(
              text: rowData.quantity?.toStringAsFixed(0) ?? '1',
              width: 1,
              styles: const PosStyles(align: PosAlign.center),
            ),
            PosColumn(
              text: rowData.subTotal.toString(),
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
      }

      bytes +=
          generator.text('------------------------------------------------');

      // Totals with custom font size
      final subTotalImage = await generateTextImage(
        'Sub Total: Tk ${sales.subTotal?.toInt().toString() ?? ''}',
        fontSize: totalFontSize,
        textAlign: TextAlign.right,
      );
      bytes += generator.image(subTotalImage);

      if (sales.discountType == 'percent') {
        final discountImage = await generateTextImage(
          'Discount (${sales.discountCalculation?.toString() ?? 0}%): Tk ${sales.discount?.toInt().toString() ?? ''}',
          fontSize: totalFontSize,
          textAlign: TextAlign.right,
        );
        bytes += generator.image(discountImage);
      } else {
        final discountImage = await generateTextImage(
          'Discount: Tk ${sales.discount?.toInt().toString() ?? ''}',
          fontSize: totalFontSize,
          textAlign: TextAlign.right,
        );
        bytes += generator.image(discountImage);
      }

      bytes +=
          generator.text('------------------------------------------------');

      final netTotalImage = await generateTextImage(
        'Net Payable: Tk ${sales.netTotal?.round().toString() ?? ''}',
        fontSize: totalFontSize + 2,
        isBold: true,
        textAlign: TextAlign.right,
      );
      bytes += generator.image(netTotalImage);

      final paidImage = await generateTextImage(
        'Paid: Tk ${sales.received?.round().toString() ?? ''}',
        fontSize: totalFontSize,
        textAlign: TextAlign.right,
      );
      bytes += generator.image(paidImage);

      if (sales.due != null && sales.due! > 0) {
        final dueImage = await generateTextImage(
          'Due: Tk ${sales.due?.toInt().toString() ?? ''}',
          fontSize: totalFontSize,
          textAlign: TextAlign.right,
        );
        bytes += generator.image(dueImage);
      }

      bytes +=
          generator.text('------------------------------------------------');

      // Sales by
      final salesByImage = await generateTextImage(
        'Sales By: ${sales.salesBy ?? 'N/A'}',
        fontSize: 12.0,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(salesByImage);
      bytes += generator.feed(1);

      // Footer
      if (SetUp().printFooter?.isNotEmpty == true) {
        final footerImage = await generateTextImage(
          SetUp().printFooter!,
          fontSize: 10.0,
          textAlign: TextAlign.center,
        );
        bytes += generator.image(footerImage);
      }

      bytes += generator.feed(newLine);

      final websiteImage = await generateTextImage(
        SetUp().website ?? 'poskeeper.com',
        fontSize: 10.0,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(websiteImage);

      bytes += generator.cut();

      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      if (kDebugMode) print('Error in printSalesWithImageControl: $e');
      return false;
    }
  }

  /// Print demo with different font sizes
  Future<bool> printFontSizeDemo() async {
    try {
      final bool connectionStatus =
          await PrintBluetoothThermal.connectionStatus;
      if (!connectionStatus) {
        showSnackBar(
          type: SnackBarType.error,
          message: appLocalization.connectPrinter,
        );
        return false;
      }

      final textLines = [
        {
          'text': 'FONT SIZE DEMO',
          'fontSize': 20.0,
          'isBold': true,
          'textAlign': TextAlign.center,
        },
        {
          'text': '=' * 32,
          'fontSize': 8.0,
          'textAlign': TextAlign.center,
        },
        {
          'text': 'Size 8px: Small text for details',
          'fontSize': 8.0,
        },
        {
          'text': 'Size 10px: Regular text',
          'fontSize': 10.0,
        },
        {
          'text': 'Size 12px: Standard size',
          'fontSize': 12.0,
        },
        {
          'text': 'Size 14px: Medium text',
          'fontSize': 14.0,
          'isBold': true,
        },
        {
          'text': 'Size 16px: Large text',
          'fontSize': 16.0,
          'isBold': true,
        },
        {
          'text': 'Size 20px: Extra Large',
          'fontSize': 20.0,
          'isBold': true,
        },
        {
          'text': 'Size 24px: Huge!',
          'fontSize': 24.0,
          'isBold': true,
          'textAlign': TextAlign.center,
        },
        {
          'text': 'Perfect font control with image-based printing!',
          'fontSize': 10.0,
          'textAlign': TextAlign.center,
        },
      ];

      return await printMultiSizeText(textLines);
    } catch (e) {
      if (kDebugMode) print('Error in printFontSizeDemo: $e');
      return false;
    }
  }

  /// Image-based sales without invoice printing
  Future<bool> _printSalesWithoutInvoiceImageBased(
    CustomerLedger ledger, {
    double headerFontSize = 18.0,
    double contentFontSize = 12.0,
  }) async {
    try {
      final profile = await CapabilityProfile.load();
      final paperType = await prefs.getPrintPaperType();
      final generator = Generator(
        paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];
      bytes += generator.reset();

      // Shop name
      final shopNameImage = await generateTextImage(
        SetUp().name ?? '',
        fontSize: headerFontSize,
        isBold: true,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(shopNameImage);

      // Address
      final addressImage = await generateTextImage(
        SetUp().address ?? '',
        fontSize: contentFontSize,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(addressImage);
      bytes += generator.feed(1);

      // Receipt Print header
      final receiptHeaderImage = await generateTextImage(
        'Receipt Print',
        fontSize: headerFontSize - 2,
        isBold: true,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(receiptHeaderImage);
      bytes += generator.feed(1);

      // Invoice
      final invoiceImage = await generateTextImage(
        'Invoice: ${ledger.invoice ?? ''}',
        fontSize: contentFontSize,
      );
      bytes += generator.image(invoiceImage);

      // Date
      final dateImage = await generateTextImage(
        'Date: ${ledger.created ?? ''}',
        fontSize: contentFontSize,
      );
      bytes += generator.image(dateImage);

      // Customer
      final customerImage = await generateTextImage(
        'Customer: ${ledger.customerName ?? ''}',
        fontSize: contentFontSize,
      );
      bytes += generator.image(customerImage);

      // Mobile
      final mobileImage = await generateTextImage(
        'Mobile: ${ledger.mobile ?? ''}',
        fontSize: contentFontSize,
      );
      bytes += generator.image(mobileImage);

      // Method
      final methodImage = await generateTextImage(
        'Method: ${ledger.method ?? 'N/A'}',
        fontSize: contentFontSize,
      );
      bytes += generator.image(methodImage);

      bytes += generator.feed(1);
      bytes +=
          generator.text('------------------------------------------------');

      // Amount received
      final amountImage = await generateTextImage(
        'Received: Tk ${ledger.amount?.toString() ?? ''}',
        fontSize: headerFontSize - 2,
        isBold: true,
        textAlign: TextAlign.right,
      );
      bytes += generator.image(amountImage);

      bytes +=
          generator.text('------------------------------------------------');

      // Footer
      if (SetUp().printFooter?.isNotEmpty == true) {
        final footerImage = await generateTextImage(
          SetUp().printFooter!,
          fontSize: contentFontSize - 2,
          textAlign: TextAlign.center,
        );
        bytes += generator.image(footerImage);
      }

      bytes += generator.feed(newLine);

      final websiteImage = await generateTextImage(
        SetUp().website ?? 'poskeeper.com',
        fontSize: contentFontSize - 2,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(websiteImage);

      bytes += generator.cut();

      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      if (kDebugMode) print('Error in _printSalesWithoutInvoiceImageBased: $e');
      return false;
    }
  }

  /// Image-based kitchen printing
  Future<bool> _printKitchenImageBased({
    required Sales sales,
    required String table,
    required String orderTakenBy,
    double headerFontSize = 18.0,
    double itemFontSize = 14.0,
  }) async {
    try {
      final profile = await CapabilityProfile.load();
      final paperType = await prefs.getPrintPaperType();
      final generator = Generator(
        paperType == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];
      bytes += generator.reset();

      // Kitchen header
      final kitchenHeaderImage = await generateTextImage(
        'Kitchen',
        fontSize: headerFontSize + 4,
        isBold: true,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(kitchenHeaderImage);

      // Shop name
      final shopNameImage = await generateTextImage(
        SetUp().name ?? '',
        fontSize: headerFontSize - 2,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(shopNameImage);
      bytes += generator.feed(1);

      bytes +=
          generator.text('------------------------------------------------');

      // Token number
      final tokenImage = await generateTextImage(
        'Token No: ${sales.tokenNo}',
        fontSize: headerFontSize,
        isBold: true,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(tokenImage);

      bytes +=
          generator.text('------------------------------------------------');

      // Table and Bill info
      final tableInfoImage = await generateTextImage(
        '${appLocalization.table}: $table    Bill: ${sales.invoice ?? ''}',
        fontSize: itemFontSize,
      );
      bytes += generator.image(tableInfoImage);

      // Date
      final dateImage = await generateTextImage(
        'Date: ${sales.createdAt.toString()}',
        fontSize: itemFontSize,
      );
      bytes += generator.image(dateImage);

      // Order taken by
      final orderTakenByImage = await generateTextImage(
        '${appLocalization.orderTakenBy}: $orderTakenBy',
        fontSize: itemFontSize,
      );
      bytes += generator.image(orderTakenByImage);

      bytes += generator.feed(1);

      // Headers
      final headerImage = await generateTextImage(
        'Item Name                    Qty',
        fontSize: itemFontSize,
        isBold: true,
      );
      bytes += generator.image(headerImage);

      bytes +=
          generator.text('------------------------------------------------');

      // Items
      if (sales.salesItem != null && sales.salesItem!.isNotEmpty) {
        for (final SalesItem rowData in sales.salesItem!) {
          final itemText = '${rowData.stockName ?? ''}';
          final qtyText = '${rowData.quantity?.toString() ?? ''}';

          // Create a formatted line with item name and quantity
          final itemLineImage = await generateTextImage(
            '$itemText${' ' * (25 - itemText.length)}$qtyText',
            fontSize: itemFontSize,
          );
          bytes += generator.image(itemLineImage);
        }
      }

      bytes += generator.feed(1);

      // Footer
      if (SetUp().printFooter?.isNotEmpty == true) {
        final footerImage = await generateTextImage(
          SetUp().printFooter!,
          fontSize: itemFontSize - 2,
          textAlign: TextAlign.center,
        );
        bytes += generator.image(footerImage);
      }

      bytes += generator.feed(newLine);

      final websiteImage = await generateTextImage(
        SetUp().website ?? 'poskeeper.com',
        fontSize: itemFontSize - 2,
        textAlign: TextAlign.center,
      );
      bytes += generator.image(websiteImage);

      bytes += generator.cut();

      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      if (kDebugMode) print('Error in _printKitchenImageBased: $e');
      return false;
    }
  }
}

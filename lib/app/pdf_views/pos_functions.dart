import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/customer_ledger.dart';
import 'package:sandra/app/entity/vendor.dart';
import 'package:sandra/app/entity/vendor_ledger.dart';

import '../core/core_model/setup.dart';

class PosTemplate extends PrinterController {
  Future<List<int>> customerLedgerTemplate({
    required List<CustomerLedger> ledger,
    required Customer customer,
  }) async {
    num totalSales = 0;
    num totalReceive = 0;

    for (final item in ledger) {
      totalSales += item.total ?? 0;
      totalReceive += item.amount ?? 0;
    }

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
      isEnglish(SetUp().name ?? '') ? SetUp().name ?? '' : 'Shop Name',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      isEnglish(SetUp().address ?? '') ? SetUp().address ?? '' : 'Shop Address',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: customer.name ?? '',
          width: 6,
        ),
        PosColumn(
          text: customer.mobile ?? '',
          width: 6,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'Balance: ',
          width: 3,
        ),
        PosColumn(
          text: customer.balance.toString(),
          width: 3,
        ),
        PosColumn(
          text: customer.address ?? '',
          width: 6,
        ),
      ],
    );
    bytes += generator.feed(1);

    // Add table headers
    bytes += generator.row(
      [
        PosColumn(
          text: 'Date',
          width: 4,
        ),
        PosColumn(
          text: 'Method',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Sales',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: 'Receive',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: 'Balance',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.text('------------------------------------------------');

    if (ledger.isNotEmpty) {
      for (final CustomerLedger rowData in ledger) {
        bytes += generator.row(
          [
            PosColumn(
              text: rowData.created?.split(' ')[0] ?? '',
              width: 4,
            ),
            PosColumn(
              text: rowData.method?.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: rowData.total?.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: rowData.amount.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: rowData.balance.toString() ?? '',
              width: 2,
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
        text: appLocalization.total,
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: 'Tk',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: totalSales.toStringAsFixed(0) ?? '',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: totalReceive.toStringAsFixed(0) ?? '',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: (totalSales - totalReceive).toStringAsFixed(0) ?? '',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

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
      SetUp().website ?? 'TerminalBd.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    return bytes;
  }

  Future<List<int>> vendorLedgerTemplate({
    required List<VendorLedger> ledger,
    required Vendor vendor,
  }) async {
    num totalSales = 0;
    num totalReceive = 0;

    for (final item in ledger) {
      totalSales += item.total ?? 0;
      totalReceive += item.amount ?? 0;
    }

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
      isEnglish(SetUp().name ?? '') ? SetUp().name ?? '' : 'Shop Name',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    // Add subtitle
    bytes += generator.text(
      isEnglish(SetUp().address ?? '') ? SetUp().address ?? '' : 'Shop Address',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
      linesAfter: 1,
    );

    bytes += generator.row(
      [
        PosColumn(
          text: vendor.name ?? '',
          width: 6,
        ),
        PosColumn(
          text: vendor.mobile ?? '',
          width: 6,
        ),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
          text: 'Balance: ',
          width: 3,
        ),
        PosColumn(
          text: vendor.balance.toString(),
          width: 3,
        ),
        PosColumn(
          text: vendor.address ?? '',
          width: 6,
        ),
      ],
    );
    bytes += generator.feed(1);

    // Add table headers
    bytes += generator.row(
      [
        PosColumn(
          text: 'Date',
          width: 4,
        ),
        PosColumn(
          text: 'Method',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Purchase',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: 'Payment',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          text: 'Balance',
          width: 2,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ],
    );
    bytes += generator.text('------------------------------------------------');

    if (ledger.isNotEmpty) {
      for (final VendorLedger rowData in ledger) {
        bytes += generator.row(
          [
            PosColumn(
              text: rowData.created?.split(' ')[0] ?? '',
              width: 4,
            ),
            PosColumn(
              text: rowData.method?.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: rowData.total?.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: rowData.amount.toString() ?? '',
              width: 2,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: rowData.balance.toString() ?? '',
              width: 2,
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
        text: appLocalization.total,
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: 'Tk',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: totalSales.toStringAsFixed(0) ?? '',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: totalReceive.toStringAsFixed(0) ?? '',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
      PosColumn(
        text: (totalSales - totalReceive).toStringAsFixed(0) ?? '',
        width: 2,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

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
      SetUp().website ?? 'TerminalBd.com',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    return bytes;
  }
}

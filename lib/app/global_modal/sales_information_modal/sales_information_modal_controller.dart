import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '/app/core/abstract_controller/printer_controller.dart';
import '/app/core/utils/static_utility_function.dart';
import '/app/core/widget/dialog_pattern.dart';
import '/app/entity/sales.dart';
import '/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';
import '/app/routes/app_pages.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class SalesInformationModalController extends PrinterController {
  final String salesMode;
  Rx<Sales?> sales = Rx<Sales?>(null);

  SalesInformationModalController({
    required Sales sales,
    required this.salesMode,
  }) {
    this.sales.value = sales;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if (salesMode == 'online') {
      await getSalesItemList();
    }
  }

  Future<void> getSalesItemList() async {
    await dataFetcher(
      future: () async {
        final data = await services.getOnlineSalesDetails(
          id: sales.value!.salesId!,
        );
        if (data != null) {
          sales
            ..value = data
            ..refresh();
          update();
          notifyChildrens();
          refresh();
        }
      },
    );
  }

  Future<void> salesPrint(BuildContext context) async {
    final isPrinted = await printSales(sales.value!);
    if (isPrinted) {
      return;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogPattern(
            title: 'title',
            subTitle: 'subTitle',
            child: PrinterConnectModalView(),
          );
        },
      );
    }
  }

  Future<void> copySales() async {
    if (salesMode == 'hold') {
      await dbHelper.deleteAllWhr(
        tbl: dbTables.tableSale,
        where: 'sales_id = ?',
        whereArgs: [sales.value?.salesId],
      );
    }

    Get
      ..back()
      ..offNamed(
        Routes.createSales,
        arguments: {
          'sales_item_list': sales.value?.salesItem,
        },
      );
  }

  void goToEditSales() {
    Get
      ..back()
      ..offNamed(
        Routes.createSales,
        arguments: {
          'sales': sales.value,
        },
      );
  }

  Future<void> deleteSales({
    required Function? onDeleted,
  }) async {
    final confirmation = await confirmationModal(
      msg: appLocalization.areYouSure,
    );

    if (confirmation) {
      bool isDeleted = false;
      if (salesMode == 'online') {
        await dataFetcher(
          future: () async {
            isDeleted = await services.deleteSales(
              id: sales.value!.salesId!,
            );
          },
        );
      } else {
        await dbHelper.deleteAllWhr(
          tbl: dbTables.tableSale,
          where: 'sales_id = ?',
          whereArgs: [sales.value!.salesId],
        );
        isDeleted = true;
      }
      if (isDeleted) {
        onDeleted!();
      }
    }
  }

  Future<void> shareContent() async {
    print('Creating and sharing PDF content...');
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Hello World!'),
        ),
      ),
    );

    try {
      // Get the directory to save the PDF
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/example.pdf');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      // Open the PDF in an external viewer
      await OpenFilex.open(file.path);
    } catch (e) {
      print('Error creating or opening PDF: $e');
    }
  }

  Future<void> createSalesDetailsPdf({
    required Sales sales,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header Section
              pw.Container(
                child: pw.Text(
                  '${setUp.name}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                child: pw.Text(
                  '${setUp.address}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                child: pw.Text(
                  'Sales Invoice',
                  style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Customer Details Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                /*decoration: pw.BoxDecoration(
                  color: PdfColors.green100,
                  borderRadius: pw.BorderRadius.circular(5),
                ),*/
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Customer: ${sales.customerName}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Invoice: ${sales.invoice}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Contact: ${sales.customerMobile}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Approve By: ${sales.approvedBy ?? 'N/A'}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Date: ${sales.createdAt}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Method: ${sales.methodName ?? 'N/A'}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Sales Item Table
              pw.TableHelper.fromTextArray(
                headers: ['S/N', 'Name of Particular', 'Price', 'QTY', 'Total'],
                data: sales.salesItem!
                    .map(
                      (item) => [
                        (sales.salesItem!.indexOf(item) + 1)
                            .toString()
                            .padLeft(2, '0'),
                        item.stockName,
                        item.mrpPrice.toString(),
                        item.quantity.toString(),
                        item.subTotal.toString(),
                      ],
                    )
                    .toList(),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
                cellStyle: pw.TextStyle(fontSize: 10),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellHeight: 25,
                headerAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                },
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                },
                columnWidths: {
                  0: pw.FlexColumnWidth(.4),
                  1: pw.FlexColumnWidth(3),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                },
              ),

              pw.TableHelper.fromTextArray(
                headers: null,
                data: [
                  ['SubTotal', '${sales.subTotal}'],
                  [
                    'Discount (${sales.discountCalculation.toString()})',
                    '${sales.discount}'
                  ],
                  ['Total', '${sales.netTotal}'],
                  ['Receive', '${sales.received}'],
                  ['Due', '${sales.due}'],
                ],
                columnWidths: {
                  0: pw.FlexColumnWidth(5.4),
                  1: pw.FlexColumnWidth(1),
                },
                cellStyle: pw.TextStyle(fontSize: 10),
                headerStyle: pw.TextStyle(fontSize: 10),
                cellHeight: 25,
                cellAlignments: {
                  0: pw.Alignment.centerRight,
                  1: pw.Alignment.centerRight,
                },
              ),
              pw.SizedBox(height: 10),

              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    // Save and open the PDF
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/sales_details.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      print('Error creating PDF: $e');
    }
  }

  pw.Widget _buildTotalRow(String title, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          '$title',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: pw.Text(
            ':',
            style: const pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(
            fontSize: 12,
          ),
          textAlign: pw.TextAlign.right,
        ),
      ],
    );
  }

  pw.Widget _buildIcon(PdfColor color, String label) {
    return pw.Column(
      children: [
        pw.Container(
          width: 40,
          height: 40,
          decoration: pw.BoxDecoration(
            color: color,
            shape: pw.BoxShape.circle,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 8),
        ),
      ],
    );
  }
}

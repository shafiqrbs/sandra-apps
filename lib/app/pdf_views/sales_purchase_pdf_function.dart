import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/customer_ledger.dart';
import 'package:sandra/app/entity/purchase.dart';
import 'package:sandra/app/entity/sales.dart';

Future<void> generateSalesPdf(Sales sales) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header Section
              pw.Container(
                child: pw.Text(
                  '${SetUp().name}',
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
                  '${SetUp().address}',
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
                  ['Due', '${(sales.netTotal ?? 0) - (sales.received ?? 0)}'],
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
          )
        ];
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'sales_details.pdf');
}

Future<void> generatePurchasePdf(Purchase purchase) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header Section
              pw.Container(
                child: pw.Text(
                  '${SetUp().name}',
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
                  '${SetUp().address}',
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
                  'Purchase Invoice',
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
                          'Vendor: ${purchase.vendorName}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Invoice: ${purchase.invoice}',
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
                          'Contact: ${purchase.vendorMobile}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Approve By: ${purchase.approvedBy ?? 'N/A'}',
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
                          'Date: ${purchase.createdAt}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Method: ${purchase.methodName ?? 'N/A'}',
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
                data: purchase.purchaseItem!
                    .map(
                      (item) => [
                        (purchase.purchaseItem!.indexOf(item) + 1)
                            .toString()
                            .padLeft(2, '0'),
                        item.stockName,
                        item.price.toString(),
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
                  ['SubTotal', '${purchase.subTotal}'],
                  [
                    'Discount (${purchase.discountCalculation.toString()})',
                    '${purchase.discount}'
                  ],
                  ['Total', '${purchase.netTotal}'],
                  ['Payment', '${purchase.received}'],
                  [
                    'Due',
                    '${(purchase.netTotal ?? 0) - (purchase.received?.toDouble() ?? 0)}'
                  ],
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
          )
        ];
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'purchase_details.pdf');
}

Future<void> generateCustomerLedgerPdf({
  required List<CustomerLedger> ledger,
  required Customer customer,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header Section
              pw.Container(
                child: pw.Text(
                  '${SetUp().name}',
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
                  '${SetUp().address}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Customer: ${customer.name}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Contact: ${customer.mobile}',
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
                          'Balance: ${customer.balance}',
                          style: pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Address: ${customer.address ?? 'N/A'}',
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

              // Sales Item Table
              pw.TableHelper.fromTextArray(
                headers: [
                  'S/N',
                  'Date',
                  'Method',
                  'Sales',
                  'Receive',
                  'Balance'
                ],
                data: ledger
                    .map(
                      (item) => [
                        (ledger.indexOf(item) + 1).toString().padLeft(2, '0'),
                        item.created,
                        item.method,
                        item.sales.toString(),
                        item.receive.toString(),
                        item.balance.toString(),
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
                  4: pw.Alignment.center,
                  5: pw.Alignment.centerRight,
                },
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                  5: pw.Alignment.centerRight,
                },
                columnWidths: {
                  0: pw.FlexColumnWidth(.4),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(1),
                },
              ),

              pw.TableHelper.fromTextArray(
                headers: null,
                data: [
                  ['SubTotal', ''],
                  ['Discount ', ''],
                  ['Total', ''],
                  ['Payment', ''],
                  ['Due', ''],
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
              //pw.SizedBox(height: 10),

              //pw.SizedBox(height: 20),
            ],
          )
        ];
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'customer_ledger_report.pdf');
}

Future<void> saveAndOpenPdf(
  pw.Document pdf,
  String pathName,
) async {
  // Save and open the PDF
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$pathName');
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

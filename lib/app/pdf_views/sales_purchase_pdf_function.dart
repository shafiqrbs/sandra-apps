import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';
import 'package:sandra/app/entity/customer.dart';
import 'package:sandra/app/entity/customer_ledger.dart';
import 'package:sandra/app/entity/purchase.dart';
import 'package:sandra/app/entity/sales.dart';
import 'package:sandra/app/entity/system_overview_report.dart';
import 'package:sandra/app/entity/user_sales_overview_report.dart';
import 'package:sandra/app/entity/vendor.dart';
import 'package:sandra/app/entity/vendor_ledger.dart';

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
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Invoice: ${sales.invoice}',
                          style: const pw.TextStyle(
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
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Approve By: ${sales.approvedBy ?? 'N/A'}',
                          style: const pw.TextStyle(
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
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Method: ${sales.methodName ?? 'N/A'}',
                          style: const pw.TextStyle(
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
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw.BoxDecoration(
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
                columnWidths: const {
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
                columnWidths: const {
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
          ),
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
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Invoice: ${purchase.invoice}',
                          style: const pw.TextStyle(
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
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Approve By: ${purchase.approvedBy ?? 'N/A'}',
                          style: const pw.TextStyle(
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
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,
                        ),
                        pw.Text(
                          'Method: ${purchase.methodName ?? 'N/A'}',
                          style: const pw.TextStyle(
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
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw.BoxDecoration(
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
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                },
                columnWidths: const {
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
                    '${purchase.discount}',
                  ],
                  ['Total', '${purchase.netTotal}'],
                  ['Payment', '${purchase.received}'],
                  [
                    'Due',
                    '${(purchase.netTotal ?? 0) - (purchase.received?.toDouble() ?? 0)}',
                  ],
                ],
                columnWidths: const {
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
          ),
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
  num totalSales = 0;
  num totalReceive = 0;
  num totalBalance = 0;

  for (final item in ledger) {
    totalSales += item.total ?? 0;
    totalReceive += item.amount ?? 0;
    totalBalance += item.balance ?? 0;
  }

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        List<pw.Widget> content = [];

        // Header Section
        content.add(
          pw.Container(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  '${SetUp().name}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${SetUp().address}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  appLocalization.customerLedger,
                  style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
              ],
            ),
          ),
        );

        // Customer Info
        content.add(
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
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Contact: ${customer.mobile}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Balance: ${customer.balance}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Address: ${customer.address ?? 'N/A'}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Split large data into chunks for table rendering
        const int chunkSize = 100; // Adjust the chunk size as needed
        for (int i = 0; i < ledger.length; i += chunkSize) {
          final chunk = ledger.sublist(
            i,
            i + chunkSize > ledger.length ? ledger.length : i + chunkSize,
          );

          // Add a gap between each chunk
          content
            ..add(pw.SizedBox(height: 10))

            // Table with Header and Data Rows in Chunks
            ..add(
              pw.TableHelper.fromTextArray(
                headers: [
                  'S/N',
                  'Date',
                  'Method',
                  'Sales',
                  'Receive',
                  'Balance'
                ],
                data: chunk.map((item) {
                  final index = ledger.indexOf(item) + 1;
                  return [
                    index.toString().padLeft(2, '0'),
                    item.created,
                    item.method,
                    item.total.toString(),
                    item.amount.toString(),
                    item.balance.toString(),
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                cellHeight: 25,
                columnWidths: const {
                  0: pw.FlexColumnWidth(.4),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(1),
                },
                headerAlignments: const {
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
              ),
            );
        }

        // Footer Summary Section
        /*content.add(
          pw.SizedBox(height: 20),
        );*/
        content.add(
          pw.TableHelper.fromTextArray(
            headers: null,
            data: [
              [
                'Total',
                totalSales.toStringAsFixed(2),
                totalReceive.toStringAsFixed(2),
                (totalSales - totalReceive).toStringAsFixed(2),
              ],
            ],
            columnWidths: {
              0: pw.FlexColumnWidth(3.4),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
            },
            cellStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            headerStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.centerRight,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
            },
          ),
        );

        return content;
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'customer_ledger_report.pdf');
}

Future<void> generateVendorLedgerPdf({
  required List<VendorLedger> ledger,
  required Vendor vendor,
}) async {
  num totalSales = 0;
  num totalReceive = 0;
  num totalBalance = 0;

  for (final item in ledger) {
    totalSales += item.total ?? 0;
    totalReceive += item.amount ?? 0;
    totalBalance += item.balance ?? 0;
  }

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        List<pw.Widget> content = [];

        // Header Section
        content.add(
          pw.Container(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  '${SetUp().name}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${SetUp().address}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  appLocalization.vendorLedger,
                  style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
              ],
            ),
          ),
        );

        // Customer Info
        content.add(
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Company: ${vendor.name}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Contact: ${vendor.mobile}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Balance: ${vendor.balance}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Address: ${vendor.address ?? 'N/A'}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        // Split large data into chunks for table rendering
        const int chunkSize = 100; // Adjust the chunk size as needed
        for (int i = 0; i < ledger.length; i += chunkSize) {
          final chunk = ledger.sublist(
            i,
            i + chunkSize > ledger.length ? ledger.length : i + chunkSize,
          );

          // Add a gap between each chunk
          content
            ..add(pw.SizedBox(height: 10))

            // Table with Header and Data Rows in Chunks
            ..add(
              pw.TableHelper.fromTextArray(
                headers: [
                  'S/N',
                  'Date',
                  'Method',
                  'Purchase',
                  'Payment',
                  'Balance',
                ],
                data: chunk.map((item) {
                  final index = ledger.indexOf(item) + 1;
                  return [
                    index.toString().padLeft(2, '0'),
                    item.created,
                    item.method,
                    item.total.toString(),
                    item.amount.toString(),
                    item.balance.toString(),
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green200,
                ),
                cellHeight: 25,
                columnWidths: const {
                  0: pw.FlexColumnWidth(.4),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(1),
                },
                headerAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                  5: pw.Alignment.centerRight,
                },
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                  5: pw.Alignment.centerRight,
                },
              ),
            );
        }

        // Footer Summary Section
        /*content.add(
          pw.SizedBox(height: 20),
        );*/
        content.add(
          pw.TableHelper.fromTextArray(
            headers: null,
            data: [
              [
                'Total',
                totalSales.toStringAsFixed(2),
                totalReceive.toStringAsFixed(2),
                (totalSales - totalReceive).toStringAsFixed(2),
              ],
            ],
            columnWidths: const {
              0: pw.FlexColumnWidth(3.4),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
            },
            cellStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            headerStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
            cellHeight: 25,
            cellAlignments: const {
              0: pw.Alignment.centerRight,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
            },
          ),
        );

        return content;
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'vendor_ledger_report.pdf');
}

Future<void> generateSystemOverViewPdf(
    SystemOverViewReport systemOverview) async {
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
                  'System Overview',
                  style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Current Stock section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Current Stock',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Sales Price',
                              systemOverview.currentStock?.salesPrice ?? '',
                            ),
                            _buildLabelValue(
                              'Quantity',
                              systemOverview.currentStock?.quantity ?? '',
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Purchase Price',
                              systemOverview.currentStock?.purchasePrice ?? '',
                            ),
                            _buildLabelValue(
                              'Profit',
                              systemOverview.currentStock?.profit ?? '',
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Income',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Sales',
                              systemOverview.income?.sales ?? '',
                            ),
                            _buildLabelValue(
                              'Expense',
                              systemOverview.income?.expense ?? '',
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Purchase',
                              systemOverview.income?.purchase ?? '',
                            ),
                            _buildLabelValue(
                              'Profit',
                              systemOverview.income?.profit ?? '',
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Purchase',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Purchase',
                              systemOverview.purchase?.purchase ?? '',
                            ),
                            _buildLabelValue(
                              'Payable',
                              systemOverview.purchase?.payable ?? '',
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Payment',
                              systemOverview.purchase?.amount ?? '',
                            ),
                            pw.Container(),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Sales',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Sales',
                              systemOverview.sales?.sales ?? '',
                            ),
                            _buildLabelValue(
                              'Receivable',
                              systemOverview.sales?.receivable ?? '',
                            ),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelValue(
                              'Receive',
                              systemOverview.sales?.amount ?? '',
                            ),
                            pw.Container(),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Transaction',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildLabelValue(
                                'Cash',
                                systemOverview.transaction?.cash ?? '',
                              ),
                              _buildLabelValue(
                                'Stock Price',
                                systemOverview.transaction?.stockPrice ?? '',
                              ),
                              _buildLabelValue(
                                'Receivable',
                                systemOverview.transaction?.receivable ?? '',
                              ),
                              _buildLabelValue(
                                'Payable',
                                systemOverview.transaction?.payable ?? '',
                              ),
                              pw.SizedBox(height: 4),
                              pw.Container(
                                height: 1,
                                width: Get.width * 0.5,
                                color: PdfColors.black,
                              ),
                              pw.SizedBox(height: 4),
                              _buildLabelValue(
                                'Capital',
                                systemOverview.transaction?.capital ?? '',
                                textStyle: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _buildLabelValue('', '', isDivider: false),
                        ]),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              pw.SizedBox(height: 20),
            ],
          ),
        ];
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'system_overview_report.pdf');
}

Future<void> generateUserSalesOverViewPdf(
  UserSalesOverviewReport userSales,
) async {
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
                  'User Sales Overview',
                  style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // show user name list
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 10),
                    pw.TableHelper.fromTextArray(
                      headers: [
                        'S/N',
                        'Name',
                        'Sales',
                        'Sales Receive',
                        'Out Standing',
                        'Due Receive',
                      ],
                      data: userSales.userSales!
                          .map(
                            (item) => [
                              (userSales.userSales!.indexOf(item) + 1)
                                  .toString()
                                  .padLeft(2, '0'),
                              item.salesBy,
                              item.total.toString(),
                              item.amount.toString(),
                              ((item.total ?? 0) - (item.amount ?? 0))
                                  .toStringAsFixed(2),
                              item.dueReceive.toString(),

                            ],
                          )
                          .toList(),
                      headerStyle: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                      cellStyle: const pw.TextStyle(fontSize: 10),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.green200,
                      ),
                      cellHeight: 25,
                      columnWidths: const {
                        0: pw.FlexColumnWidth(.4),
                        1: pw.FlexColumnWidth(2),
                        2: pw.FlexColumnWidth(1),
                        3: pw.FlexColumnWidth(1),
                        4: pw.FlexColumnWidth(1),
                        5: pw.FlexColumnWidth(1),
                      },
                      headerAlignments: {
                        0: pw.Alignment.center,
                        1: pw.Alignment.centerLeft,
                        2: pw.Alignment.centerRight,
                        3: pw.Alignment.centerRight,
                        4: pw.Alignment.centerRight,
                        5: pw.Alignment.centerRight,
                      },
                      cellAlignments: {
                        0: pw.Alignment.center,
                        1: pw.Alignment.centerLeft,
                        2: pw.Alignment.centerRight,
                        3: pw.Alignment.centerRight,
                        4: pw.Alignment.centerRight,
                        5: pw.Alignment.centerRight,
                      },
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              pw.SizedBox(height: 20),
            ],
          ),
        ];
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'user_sales_overview_report.pdf');
}

Future<void> generateSalesWithoutInvoicePdf(
  CustomerLedger ledger,
) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Container(
            width: double.infinity,
            child: pw.Column(
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
                    'Customer Sales Details',
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                pw.Column(
                  children: [
                    _buildLabelValue(
                      'Invoice',
                      ledger.invoice ?? '',
                      width: Get.width,
                    ),
                    _buildLabelValue(
                      'Date',
                      ledger.created ?? '',
                      width: Get.width,
                    ),
                    _buildLabelValue(
                      'Customer',
                      ledger.customerName ?? '',
                      width: Get.width,
                    ),
                    _buildLabelValue(
                      'Contact',
                      ledger.mobile ?? '',
                      width: Get.width,
                    ),
                    _buildLabelValue(
                      'Receive',
                      ledger.amount?.toStringAsFixed(2) ?? '',
                      width: Get.width,
                    ),
                    _buildLabelValue(
                      'Method',
                      ledger.method ?? '',
                      width: Get.width,
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),
              ],
            ),
          ),
        ];
      },
    ),
  );

  await saveAndOpenPdf(pdf, 'user_sales_report.pdf');
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
    if (kDebugMode) {
      print('Error creating PDF: $e');
    }
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
        style: const pw.TextStyle(
          fontSize: 8,
        ),
      ),
    ],
  );
}

pw.Widget _buildLabelValue(
  String label,
  String value, {
  bool isDivider = true,
  pw.TextStyle? textStyle,
  double? width,
}) {
  return pw.Container(
    width: width ?? Get.width * 0.5,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: textStyle ??
                const pw.TextStyle(
                  fontSize: 12,
                ),
          ),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(left: 6, right: 6),
          child: pw.Text(
            isDivider ? ':' : '',
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: textStyle ??
                const pw.TextStyle(
                  fontSize: 12,
                ),
          ),
        ),
      ],
    ),
  );
}
